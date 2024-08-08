import 'package:flutter/material.dart';

class StoryImage extends StatelessWidget {
  final String image;

  final int index;
  const StoryImage({super.key, required this.image, required this.index});

  @override
  Widget build(BuildContext context) {
    return (index != 0)
        ? Stack(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffD300C5), Color(0xffFFD600)],
                  ),
                ),
              ),
              Positioned(
                left: 3,
                top: 3,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 29,
                    backgroundImage: AssetImage(image),
                  ),
                ),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(image),
                  radius: 32,
                ),
                Positioned(
                  bottom: 1,
                  right: 2,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Container(
                          height: 18,
                          width: 18,
                          color: const Color(0xff0095F6),
                          child: const Icon(
                            Icons.add,
                            size: 13,
                            color: Colors.white,
                          )),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: Color(0xFF0091E4),
        ),
        CircleAvatar(
          radius: 4,
          backgroundColor: Color(0xFFDFDFDF),
        ),
        CircleAvatar(
          radius: 4,
          backgroundColor: Color(0xFFDFDFDF),
        ),
        CircleAvatar(
          radius: 3,
          backgroundColor: Color(0xFFDFDFDF),
        ),
        CircleAvatar(
          radius: 2.2,
          backgroundColor: Color(0xFFDFDFDF),
        ),
      ],
    );
  }
}

class CommentProfiles extends StatelessWidget {
  const CommentProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 65,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/images/2.png'),
            ),
          ),
          Positioned(
            left: 17,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage('assets/images/1.png'),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage('assets/images/0.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
