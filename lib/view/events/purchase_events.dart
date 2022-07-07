import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/events/event_details.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class PurchaseEvents extends StatelessWidget {
  final List<Map<String, dynamic>> events = [
    {
      'eventType': 'Picnic',
      'thumbnail': Assets.imagesPicnic,
    },
    {
      'eventType': 'Events',
      'thumbnail': Assets.imagesEvents,
    },
    {
      'eventType': 'Parties',
      'thumbnail': Assets.imagesParties,
    },
    {
      'eventType': 'Babyshower',
      'thumbnail': Assets.imagesBabyShower,
    },
    {
      'eventType': 'Gender Reveal',
      'thumbnail': Assets.imagesGenderReveal,
    },
    {
      'eventType': 'Customize',
      'thumbnail': Assets.imagesCustomize,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Purchase event',
        onTap: () => Navigator.pop(context),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7,
          mainAxisSpacing: 10,
          mainAxisExtent: 168,
        ),
        physics: BouncingScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          var eventData = events[index];
          return eventsCards(
            context,
            eventData,
            index,
          );
        },
      ),
    );
  }

  Widget eventsCards(
    BuildContext context,
    Map<String, dynamic> eventData,
    int index,
  ) {
    return GestureDetector(
      onTap: index == 0
          ? () => Navigator.pushNamed(
                context,
                AppLinks.picnicPackages,
              )
          : index == events.length - 1
              ? () => Navigator.pushNamed(
                    context,
                    AppLinks.customizeEvent,
                  )
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetails(),
                    ),
                  ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(eventData['thumbnail']),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 83,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(Assets.imagesGradientEffect),
                ),
              ),
              child: MyText(
                paddingLeft: 15,
                paddingBottom: 18,
                text: '${eventData['eventType']}',
                size: 18,
                weight: FontWeight.w600,
                color: kPrimaryColor,
                fontFamily: GoogleFonts.mulish().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
