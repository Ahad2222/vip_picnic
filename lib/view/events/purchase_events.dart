import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/events/customize_event.dart';
import 'package:vip_picnic/view/events/event_details.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class PurchaseEvents extends StatelessWidget {
  final List<Map<String, dynamic>> events = [
    {
      'eventType': 'Picnic Kids',
      'thumbnail': 'https://www.vippicnic.com/img/packs/picnic.jpg',
      'des':
          'How about celebrating your little one\'s birthday in a different and original way ? Your guests will be delighted with the originality of your party, what are you waiting for… to make the reservation of their dreams, the children will not forget how beautiful their birthday party has been. We at vip picnic take care of all the details.',
    },
    {
      'eventType': 'Baby Shower',
      'thumbnail': 'https://www.vippicnic.com/img/packs/baby.jpg',
      'des':
          'If you are pregnant and you are looking for ideas to celebrate a baby shower abroad, we present this beautiful setup to you. And what to say about that exact moment at sunset where the light has those magical golden colors. if you dream about your baby shower project! VIP PICNIC team will bring all your dreams to reality.',
    },
    {
      'eventType': 'Communion',
      'thumbnail': 'https://www.vippicnic.com/img/packs/communion.jpg',
      'des':
          'Do you want an elegant, different, unique and made-to-measure first communion ? Welcome! You are at Vip picnic the Paradise of events. Our Communions are magical. Emotions flow, hosts and guests have fun, beyond time. We help you make that day perfect and that the guests do not forget how beautiful it was. In our corner you will find from the smallest to the last detail.',
    },
    {
      'eventType': 'Wedding',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_7666588.jpeg',
      'des':
          'Who doesn\'t want an unforgettable and unique wedding party? Nowadays we don\'t need to invest in a party for many guests, nor in grand scenery or sophistication, what counts is authenticity, that the party has the face of the newlyweds. Innovate and personalize your wedding day as much as possible with a unique and wonderful outdoor picnic.',
    },
    {
      'eventType': 'Birthday Party',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_9343192.jpeg',
      'des':
          'We want your celebration to be a amazing experience, a small work of art of good taste. Exclusive ideas sculpted and decorated with dedication to make this day one of the most surprising of your life, for you and for your people. Do you have something to celebrate? Do not hesitate to contact us, we are experts in organizing party’s and picnics.',
    },
    {
      'eventType': 'Gender Reveal',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_7563604.jpeg',
      'des':
          'Can you imagine super special event for a baby gender reveal, we are so happy to make our clients dreams come true and to be able to create such beautiful things for everyone who contacts us! Our picnics are always a different and creative surprise. Boy or girl ?',
    },
    {
      'eventType': 'Proposal Marriage',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_7447790.jpeg',
      'des':
          'We are specialists in the field of carrying out your project party event the way you want it. together we can brainstorm about your amazing ideas to make your dreams come true, nothing is too crazy for us! to realize your dream party. Make your reservation now.',
    },
    {
      'eventType': 'Romantic Picnic',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_6146656.jpeg',
      'des':
          'What do you think of a beach picnic together with your loved one ? your partner would be amazed how you organized everything so romantic, book this unforgettable experience now to enjoy together from this amazing moment.',
    },
    {
      'eventType': 'Mother\'s Day',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_1899010.jpeg',
      'des':
          'What do you think of a beach picnic together with your loved one ? your partner would be amazed how you organized everything so romantic, book this unforgettable experience now to enjoy together from this amazing moment.',
    },
    {
      'eventType': 'Customize',
      'thumbnail':
          'https://www.vippicnic.com/img/packs/06_25__loc_6971336.jpeg',
      'des':
          'We are specialists in the field of carrying out your project party event the way you want it. together we can brainstorm about your amazing ideas to make your dreams come true, nothing is too crazy for us! to realize your dream party. Make your reservation now.',
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomizeEvent(
            imageUrl: eventData['thumbnail'],
            eventTheme: eventData['eventType'],
            des: eventData['des'],
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              eventData['thumbnail'],
              fit: BoxFit.cover,
              width: Get.width,
              height: Get.height,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return loading();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return loading();
              },
            ),
            Container(
              height: 83,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(Assets.imagesGradientEffect),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: MyText(
                paddingLeft: 12,
                paddingBottom: 10,
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
