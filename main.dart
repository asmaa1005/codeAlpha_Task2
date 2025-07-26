import 'package:flutter/material.dart';

void main() => runApp(const FlashcardApp());

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,

      ),
      home: const FlashcardHomePage(),
    );
  }
}

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardHomePageState createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  List<Flashcard> flashcards = [
    Flashcard(question: "What is Flutter?", answer: "A UI toolkit by Google."),
    Flashcard(question: "What language is used in Flutter?", answer: "Dart."),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void _nextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showAnswer = false;
      }
    });
  }

  void _prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showAnswer = false;
      }
    });
  }

  void _addFlashcard() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: questionController, decoration: const InputDecoration(labelText: 'Question')),
            TextField(controller: answerController, decoration: const InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                setState(() {
                  flashcards.add(Flashcard(
                      question: questionController.text, answer: answerController.text));
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editFlashcard(int index) {
    TextEditingController questionController =
        TextEditingController(text: flashcards[index].question);
    TextEditingController answerController =
        TextEditingController(text: flashcards[index].answer);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: questionController, decoration: const InputDecoration(labelText: 'Question')),
            TextField(controller: answerController, decoration: const InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                setState(() {
                  flashcards[index].question = questionController.text;
                  flashcards[index].answer = answerController.text;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFlashcard(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                flashcards.removeAt(index);
                if (currentIndex > 0) currentIndex--;
                showAnswer = false;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz App',style: TextStyle(color: Color.fromARGB(255, 223, 174, 242))),
        backgroundColor: const Color.fromARGB(255, 118, 13, 167), 
        actions: [
        IconButton(
  icon: const Icon(Icons.add, color: Colors.white), 
  onPressed: _addFlashcard,
),
IconButton(
  icon: const Icon(Icons.edit, color: Colors.white), 
  onPressed: () => _editFlashcard(currentIndex),
),
IconButton(
  icon: const Icon(Icons.delete, color: Colors.white), 
  onPressed: () => _deleteFlashcard(currentIndex),
),

        ],
      ),
      body: flashcards.isEmpty
          ? const Center(
              child: Text(
                "No flashcards. Please add one.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color.fromARGB(255, 118, 13, 167),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Question',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 240, 236, 241), 
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentCard.question,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Color.fromARGB(255, 239, 236, 240),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (showAnswer) ...[
                            const Divider(height: 32),
                            const Text(
                              'Answer',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 239, 243),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentCard.answer,
                              style: TextStyle(fontSize: 22, color: const Color.fromARGB(255, 255, 255, 255)),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => showAnswer = !showAnswer),
                    icon: Icon(showAnswer ? Icons.visibility_off : Icons.visibility),
                    label: Text(showAnswer ? 'Hide Answer' : 'Show Answer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _prevCard,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: _nextCard,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Card ${currentIndex + 1} of ${flashcards.length}",
                      style: const TextStyle(color: Color.fromARGB(255, 251, 251, 251))),
                ],
              ),
            ),
    );
  }
}
