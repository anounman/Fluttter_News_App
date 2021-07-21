import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'artical.dart';
import 'newstile.dart';
import 'sliderview.dart';

bool mode = true;
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  String day = "";
  bool isDark = true;
  List <Article> news = [];
  List <Article> slider = [];
  bool _loading = true;
  String sear_query= "headline";
  String queary = "headline";
  void getNews() async {
    try {
      String url = "https://newsapi.org/v2/everything?q=${sear_query}&apiKey=0d055f929881493bbebbdef1c72989ed";
      print(url);
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((element) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
          setState(() {
            _loading = false;
          });
        });
      }
      else {
        _loading = false;
      }
    }catch (value){
      _loading = false;
    }
  }
  void Slider() async {
    try {

      String url = "https://newsapi.org/v2/everything?q=top&apiKey=0d055f929881493bbebbdef1c72989ed";
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((element) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          slider.add(article);
          setState(() {
            _loading = false;
          });
        });
      }else{
        _loading = false;
      }
    }
    catch (value){
      _loading = false;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var date = DateTime.now();
    day = DateFormat('EEEE, d MMM, yyyy').format(date);
    getNews();
    Slider();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        brightness: isDark?Brightness.light: Brightness.dark,
        ),
      home: SafeArea(
        child:
        _loading?
        Center(child: CircularProgressIndicator(color: Colors.white)):
        Scaffold(
          body: SingleChildScrollView(
            child:
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          day.text.extraBold.gray500.size(15).make().pOnly(left: 32.0, top: 20.0),
                          isDark?"Top News".text.black.extraBold.xl5.make().px32():"Top News".text.extraBold.xl5.make().px32(),
                        ],

                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          icon: (isDark?Icon(Icons.dark_mode_outlined , size: 50,) : Icon(Icons.wb_sunny_outlined , size: 50,)),
                          onPressed: () {
                            setState(() {
                              if (isDark){
                                isDark = false;
                                mode = isDark;
                              }
                              else{
                                isDark = true;
                                mode = isDark;
                              }
                            });

                          },

                        ).pOnly(top: 32 , right: 32),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                 CarouselSlider(
                   items: [
                 SlideView(
                 imgUrl: slider[0].urlToImage,
                   posturl:  slider[0].articleUrl,
                 ),
                     SlideView(
                       imgUrl: slider[1].urlToImage,
                       posturl:  slider[1].articleUrl,
                     ),
                     SlideView(
                       imgUrl: slider[2].urlToImage,
                       posturl:  slider[2].articleUrl,
                     ),SlideView(
                       imgUrl: slider[3].urlToImage,
                       posturl:  slider[3].articleUrl,
                     ),SlideView(
                       imgUrl: slider[4].urlToImage,
                       posturl:  slider[4].articleUrl,
                     )
                   ],
                   options: CarouselOptions(
                     height: 260.0,
                     enlargeCenterPage: true,
                     autoPlay: true,
                     aspectRatio: 16 / 9,
                     autoPlayCurve: Curves.fastOutSlowIn,
                     enableInfiniteScroll: true,
                     autoPlayAnimationDuration: Duration(milliseconds: 800),
                     viewportFraction: 0.8,
                   ),
                 ),
                  Stack(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                            ),
                        ),
                      ),
                        validator: (value){
                          if (value!.isEmpty){
                            setState(() {
                              sear_query = value;
                            });
                          }
                          else{
                            return "Please Enter Your Search Query";
                          }
                        },
                        onFieldSubmitted: (value){
                            setState(() {
                              _loading = true;
                              sear_query = value;
                              news = [];
                              getNews();
                            });
                        }
                        ,
                      ).p32(),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.search, size: 50,).pOnly(top:35 , left: 5, right: 35),
                      )
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  "Recent News".text.xl3.extraBold.make().pOnly(left: 32.0),
                  SizedBox(height: 20),
                    SingleChildScrollView(
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: news.length,
                          itemBuilder: (BuildContext context,int index){
                          return NewsTile(
                          imgUrl: news[index].urlToImage,
                            title: news[index].title,
                            desc: news[index].description,
                            content: news[index].content,
                            posturl: news[index].articleUrl,
                          ).p16();
                        }
                ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
