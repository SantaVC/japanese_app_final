import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import '../loaders/kana_data_loader.dart';
import '../models/kana.dart';
import '../models/kana_option.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';

class TestPage extends StatefulWidget {
  final Set<int> selectedIndexes;
  final KanaDataLoader dataLoader;
  final String testType;
  final String direction;

  const TestPage({
    super.key,
    required this.selectedIndexes,
    required this.dataLoader,
    required this.testType,
    required this.direction,
  });

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  late List<List<Kana>> testData;
  late KanaOption correctAnswer;
  late KanaOption questionSymbol;
  List<KanaOption> currentTestOptions = [];
  Queue<String> lastThreeSymbols = Queue<String>();

  bool isLoading = true;
  bool isAnswered = false;
  bool correct = true;
  int? shakeIndex;
  int correctAnswersStreak = 0;

  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    loadTestData();

    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 500));
    _bounceController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _bounceAnimation =
        Tween<double>(begin: 0.0, end: -50.0).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
            begin: const Offset(-0.02, 0.0), end: const Offset(0.02, 0.0))
        .animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticInOut,
    ));

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.reverse();
      }
    });
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text('Streak: $correctAnswersStreak',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          widget.direction == 'kanaToRomanji'
                              ? questionSymbol.kana.kana
                              : questionSymbol.kana.roumaji,
                          style: const TextStyle(
                              fontSize: 120, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.testType == 'card'
                    ? buildOptionGrid()
                    : buildInputField(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: currentTestOptions.length,
      itemBuilder: (BuildContext context, int index) {
        var option = currentTestOptions[index];
        bool isCorrectOption = widget.direction == 'kanaToRomanji'
            ? option.kana.roumaji == correctAnswer.kana.roumaji
            : option.kana.kana == correctAnswer.kana.kana;
        return AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final offset = shakeIndex == index
                ? sin(_shakeController.value * pi * 1.2) * 7
                : 0.0;
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: ElevatedButton(
            onPressed: !isAnswered && option.isEnabled
                ? () => checkAnswer(
                    index,
                    widget.direction == 'kanaToRomanji'
                        ? option.kana.roumaji
                        : option.kana.kana)
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              disabledBackgroundColor:
                  isCorrectOption ? Colors.green : Colors.red.withOpacity(0.5),
              foregroundColor: Colors.black,
            ),
            child: Text(
              widget.direction == 'kanaToRomanji'
                  ? option.kana.roumaji
                  : option.kana.kana,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget buildInputField() {
    return SlideTransition(
      position: _offsetAnimation,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Input your answer',
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: !correct ? Colors.red : Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: !correct ? Colors.red : Colors.blue, width: 2.0),
          ),
        ),
        onSubmitted: (submittedAnswer) =>
            checkAnswerForTextField(submittedAnswer),
      ),
    );
  }

  void checkAnswerForTextField(String submittedAnswer) {
    String correctAnswerText = widget.direction == 'kanaToRomanji'
        ? correctAnswer.kana.roumaji.toLowerCase()
        : correctAnswer.kana.kana.toLowerCase();

    submittedAnswer = submittedAnswer.trim().toLowerCase();

    bool isCorrectAnswer =
        submittedAnswer == correctAnswerText && widget.testType == 'write';

    if (isCorrectAnswer) {
      _bounceController.forward(from: 0.0);
      _playConfetti();
      setState(() {
        isAnswered = true;
        correct = true;
        _controller.clear();
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          generateTest();
          setState(() {
            isAnswered = false;
          });
        }
      });
    } else {
      setState(() {
        correct = false;
      });
      _shakeController.forward(from: 0.0);
    }
  }

  void loadTestData() async {
    var allData = await widget.dataLoader.loadKanaData();
    testData = widget.selectedIndexes.map((index) => allData[index]).toList();
    isLoading = false;
    generateTest();
    setState(() {});
  }

  void _playConfetti() {
    var settings = Provider.of<AppSettings>(context, listen: false);
    if (settings.enableConfetti) {
      _confettiController.play();
    }
  }

  void generateTest() {
    final random = Random();
    List<Kana> allKanas = testData.expand((group) => group).toList();

    List<Kana> filteredKanas = allKanas
        .where((kana) =>
            !lastThreeSymbols.contains(widget.direction == 'kanaToRomanji'
                ? kana.roumaji
                : kana.kana) &&
            kana.roumaji.isNotEmpty &&
            kana.kana.isNotEmpty)
        .toList();

    if (filteredKanas.isEmpty) {
      lastThreeSymbols.clear();
      filteredKanas = allKanas
          .where((kana) => kana.roumaji.isNotEmpty && kana.kana.isNotEmpty)
          .toList();
    }

    if (filteredKanas.isEmpty) {
      throw Exception('No valid kanas available to generate a test.');
    }

    Kana questionKana = filteredKanas[random.nextInt(filteredKanas.length)];
    correctAnswer = KanaOption(kana: questionKana);
    questionSymbol = correctAnswer;

    updateLastSymbols(widget.direction == 'kanaToRomanji'
        ? questionKana.roumaji
        : questionKana.kana);

    Set<String> seen = {
      widget.direction == 'kanaToRomanji'
          ? questionKana.roumaji
          : questionKana.kana
    };
    List<String> options = [seen.first];

    List<Kana> optionCandidates = allKanas
        .where((kana) =>
            !seen.contains(widget.direction == 'kanaToRomanji'
                ? kana.roumaji
                : kana.kana) &&
            kana.roumaji.isNotEmpty &&
            kana.kana.isNotEmpty)
        .toList();

    while (options.length < 4 && optionCandidates.isNotEmpty) {
      Kana option = optionCandidates[random.nextInt(optionCandidates.length)];
      String optionText =
          widget.direction == 'kanaToRomanji' ? option.roumaji : option.kana;

      if (!seen.contains(optionText) && optionText.isNotEmpty) {
        options.add(optionText);
        seen.add(optionText);
      }
    }

    if (options.length < 4) {
      throw Exception('Not enough valid options to form a test.');
    }

    options.shuffle();
    currentTestOptions = options
        .map((optionText) => KanaOption(
            kana: widget.direction == 'kanaToRomanji'
                ? Kana(kana: '', roumaji: optionText, type: '')
                : Kana(kana: optionText, roumaji: optionText, type: '')))
        .toList();
  }

  void updateLastSymbols(String newSymbol) {
    if (lastThreeSymbols.length >= 3) {
      lastThreeSymbols.removeFirst();
    }
    lastThreeSymbols.addLast(newSymbol);
  }

  void checkAnswer(int index, String selectedOption) {
    String correctAnswerText = widget.direction == 'kanaToRomanji'
        ? correctAnswer.kana.roumaji
        : correctAnswer.kana.kana;

    if (selectedOption == correctAnswerText) {
      _bounceController.forward(from: 0.0);
      _playConfetti();
      setState(() {
        isAnswered = true;
        correct = true;
        correctAnswersStreak++;
        for (var option in currentTestOptions) {
          option.isEnabled = false;
        }
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          generateTest();
          setState(() {
            isAnswered = false;
            shakeIndex = null;
            for (var option in currentTestOptions) {
              option.isEnabled = true;
            }
          });
        }
      });
    } else {
      setState(() {
        shakeIndex = index;
        currentTestOptions[index].isEnabled = false;
        correct = false;
        correctAnswersStreak = 0;
      });
      _shakeController.forward(from: 0.0);
    }
  }
}
