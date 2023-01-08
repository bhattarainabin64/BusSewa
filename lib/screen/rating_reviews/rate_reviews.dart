import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:snack/snack.dart';

class RateReviewScreen extends StatefulWidget {
  const RateReviewScreen({
    super.key,
    required this.driverId,
    required this.riderId,
  });
  final String driverId;
  final String riderId;

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> {
  double _ratingValue = 0.0;
  bool selected = false;
  bool? isRated;
  // text controller
  final TextEditingController _textController = TextEditingController();

  void giveRating() {
    if (isRated == true) {
      const SnackBar(content: Text('You have already rated this driver'))
          .show(context);
      return;
    }
    try {
      DatabaseReference newRatingRef =
          FirebaseDatabase.instance.ref().child('user/${widget.driverId}');

      // updating array in firebase

      DatabaseReference historyRef = FirebaseDatabase.instance
          .ref()
          .child('user/${widget.driverId}/rating');

      // make json
      final json = {
        'ratingValue': _ratingValue,
        'review': _textController.text,
        'experience': _selectedValue,
        'givenBy': widget.riderId,
      };

      // create new rating
      historyRef.push().set(json);

      Navigator.pushNamed(context, '/dashboard');

      const SnackBar(content: Text('Thankyou for your rating!')).show(context);
    } catch (e) {
      SnackBar(content: Text('$e')).show(context);
    }
  }

  String _selectedValue = 'Good';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Share your experience",
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                'rate the driver',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // implement the rating bar
              RatingBar(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                      full: const Icon(Icons.star, color: Colors.black),
                      half: const Icon(
                        Icons.star_half,
                        color: Colors.black,
                      ),
                      empty: const Icon(
                        Icons.star_outline,
                        color: Colors.black,
                      )),
                  onRatingUpdate: (value) {
                    setState(() {
                      _ratingValue = value;
                    });
                  }),
              const SizedBox(height: 25),
              // Display the rate in number
              Container(
                width: 200,
                height: 60,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.rectangle),
                alignment: Alignment.center,
                child: Text(
                  _ratingValue != null ? _ratingValue.toString() : 'Rate it!',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Text(widget.driverId),

              // trip experience selectable list
              const SizedBox(height: 25),
              const Text(
                'Trip Experience',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),

              // choice chip
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    selectedColor: Colors.green,
                    label: const Text('Good'),
                    selected: _selectedValue == 'Good',
                    onSelected: (selected) {
                      setState(() {
                        _selectedValue = 'Good';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Average'),
                    selectedColor: Colors.orange,
                    selected: _selectedValue == 'Average',
                    onSelected: (selected) {
                      setState(() {
                        _selectedValue = 'Average';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Bad'),
                    selectedColor: Colors.red,
                    selected: _selectedValue == 'Bad',
                    onSelected: (selected) {
                      setState(() {
                        _selectedValue = 'Bad';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // trip experience selectable list
              const Text(
                'Write a review',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              // Text input field
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your review here (optional))',

                    // border color
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  maxLines: 2,
                ),
              ),

              // submit button
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    giveRating();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    // full width button
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
