import 'package:flutter/material.dart';
import 'package:pos/constants/image_strings.dart';
import 'package:pos/constants/text_string.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'getbussiness_detail.dart';

class MobileOnboarding extends StatefulWidget {
  const MobileOnboarding({super.key});

  @override
  State<MobileOnboarding> createState() => _MobileOnboardingState();
}

class _MobileOnboardingState extends State<MobileOnboarding> {
  final PageController _pageController=PageController();

  int currentindex=0;

  changeindex(int index){
    setState(() {
      currentindex=index;
    });
    _pageController.jumpToPage(currentindex);
  }
  forwardicon(int index){
    if(index==2){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetbussinessDetail(),));
    }else{
      setState(() {
        currentindex=index+1;
      });
      _pageController.jumpToPage(currentindex);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children:[
            Container(
              margin: const EdgeInsets.all(10),
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) => changeindex(value),
                children: const [
                  Onboard(imageassets: Eimages.onboardinggif1, title: Etexts.onboardingtitle1, subtitle: Etexts.onboardingsubtitle1),
                  Onboard(imageassets: Eimages.onboardinggif2, title: Etexts.onboardingtitle2, subtitle: Etexts.onboardingsubtitle2),
                  Onboard(imageassets: Eimages.onboardinggif3, title: Etexts.onboardingtitle3, subtitle: Etexts.onboardingsubtitle3),
                  ],
              ),
            ),
            Positioned(
                bottom: 40,
                left: 10,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(dotHeight: 10,activeDotColor: Colors.blueAccent,dotColor: Colors.grey),
                  onDotClicked: (index) => changeindex(index),
                )),
            Positioned(
                bottom: 20,
                right: 10,
                child: ElevatedButton(onPressed: (){forwardicon(currentindex);},child:const Icon(Icons.arrow_forward_ios),)),
            Positioned(
              top: 30,
              right: 1,
              child: TextButton(
                  onPressed: (){
                    // print("pressed");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetbussinessDetail(),));
                  }, child: Text("Skip",style: Theme.of(context).textTheme.headlineSmall,)
              ),
            ),
          ]
      )
    );
  }
}
class Onboard extends StatelessWidget{
  final String imageassets;
  final String title;
  final String subtitle;

  const Onboard({super.key, required this.imageassets, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height*0.65,
          child: Image.asset(imageassets,fit: BoxFit.contain),
        ),
        Text(title,style: Theme.of(context).textTheme.titleLarge,),
        const SizedBox(height: 10,),
        Text(subtitle,style: Theme.of(context).textTheme.titleSmall,),
      ],
    );
  }
}


