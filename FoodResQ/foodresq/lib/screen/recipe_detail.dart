import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/component/heading_text.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/controller/recipes_controller.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/models/recipes_model.dart';
import 'package:foodresq/component/touchable_feedback.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/screen/ingredient_listtile_widget.dart';
import 'package:foodresq/screen/select_ingredient.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/screen/recipes_listing.dart';
import 'package:foodresq/utilities/helper.dart';
// import 'package:foodresq/controller/recipes_controller.dart';
import 'package:http/http.dart' as http;

import '../main_local.dart';
import '../size_config.dart';
import 'home.dart';
import 'ingredient_listing.dart';

//TODO: redeem need check verified with back end dont use current state only
class RecipeDetailPage extends HookConsumerWidget {
  static String routeName = "/recipe_detail";
  final String title;
  final Recipes recipe;

  const RecipeDetailPage({Key? key, required this.title, required this.recipe})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          title,
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
        return Column(
          children: [
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          '${recipe.recipeImage}',
                        ),
                      ),
                      // Stack(
                      //   children: [

                      //     discount.gallery == null
                      //         ? CustomCachedNetworkImage(
                      //             boxfit: BoxFit.contain,
                      //             image:
                      //                 'https://ksyong.s3.ap-southeast-1.amazonaws.com/ugek-logo.png',
                      //           )
                      //         : CarouselSlider(
                      //             carouselController: _controller,
                      //             options: CarouselOptions(
                      //                 // height: 400,
                      //                 aspectRatio: 16 / 9,
                      //                 viewportFraction: 1,
                      //                 initialPage: 0,
                      //                 // reverse: false,
                      //                 scrollDirection: Axis.horizontal,
                      //                 onPageChanged: (index, reason) {
                      //                   _current.value = index;
                      //                 }),
                      //             items: discount.gallery!.map((item) {
                      //               return Builder(
                      //                 builder: (BuildContext context) {
                      //                   return CustomCachedNetworkImage(
                      //                       image: item);
                      //                 },
                      //               );
                      //             }).toList(),
                      //           ),
                      //     Positioned.fill(
                      //       child: Align(
                      //         alignment: Alignment.bottomCenter,
                      //         child: Container(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: discount.gallery!
                      //                 .asMap()
                      //                 .entries
                      //                 .map((entry) {
                      //               return Container(
                      //                 width: 8.0,
                      //                 height: 8.0,
                      //                 margin: EdgeInsets.symmetric(
                      //                     vertical: 8.0, horizontal: 4.0),
                      //                 decoration: BoxDecoration(
                      //                   shape: BoxShape.circle,
                      //                   color: (Theme.of(context).brightness ==
                      //                               Brightness.dark
                      //                           ? Colors.white
                      //                           : Colors.black)
                      //                       .withOpacity(
                      //                           _current.value == entry.key
                      //                               ? 0.8
                      //                               : 0.2),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          getProportionateScreenWidth(20),
                          getProportionateScreenHeight(10),
                          getProportionateScreenWidth(20),
                          getProportionateScreenHeight(20),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Center(
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: getProportionateScreenHeight(10),
                            //     ),
                            //     width: getProportionateScreenWidth(80),
                            //     child: Divider(
                            //       thickness: 3,
                            //       color: ColourConstant.kTextColor,
                            //     ),
                            //   ),
                            // ),
                            // HeadingText(
                            //   text: "Malaysian Food",
                            //   heading: 3,
                            //   textColor: ColourConstant.kTextColor,
                            // ),
                            SizedBox(
                              height: getProportionateScreenHeight(8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: NormalText(
                                    text: "${recipe.recipeName}",
                                    textColor: Colors.black,
                                    fontSize: 20,
                                    align: TextAlign.center,
                                    isBold: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (recipe.recipeLevel == "Beginner")
                                        RecipeCardTag(
                                          tag: "Beginner",
                                          color: Colors.green,
                                        ),
                                      if (recipe.recipeLevel == "Intermediate")
                                        RecipeCardTag(
                                          tag: "Intermediate",
                                          color: Colors.orange,
                                        ),
                                      if (recipe.recipeLevel == "Masterchef")
                                        RecipeCardTag(
                                          tag: "Masterchef",
                                          color: Colors.red,
                                        ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   flex: 3,
                                //   child: Container(
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.end,
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //       children: [
                                //         if (discount.whatsapp != null)
                                //           if (discount.whatsapp!.length > 0)
                                //             DefaultIconButton(
                                //               size: 25,
                                //               icon: UgekIcons.whatapps,
                                //               press: () {
                                //                 launchWhatsApp(
                                //                     hpNumber: discount.whatsapp!);
                                //               },
                                //             ),
                                //         DefaultIconButton(
                                //           size: 25,
                                //           icon: discount.isSaved
                                //               ? UgekIcons.liked
                                //               : UgekIcons.unliked,
                                //           press: () async {
                                //             await ref
                                //                 .read(
                                //                     discountDetailControllerProvider(
                                //                             discountRedeemId)
                                //                         .notifier)
                                //                 .saveDiscount(
                                //                     savedDiscount:
                                //                         discount.copyWith(
                                //                             isSaved: !discount
                                //                                 .isSaved));
                                //           },
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(8),
                            ),
                            // Divider(
                            //   thickness: 1,
                            //   color: Colors.black,
                            //   height: getProportionateScreenHeight(30),
                            // ),
                            // if (discount.discountType == DiscountType.IN_STORE)
                            //   Text.rich(
                            //     TextSpan(
                            //       style: TextStyle(
                            //         fontSize: 17,
                            //       ),
                            //       children: [
                            //         WidgetSpan(
                            //           child: Icon(
                            //             FontAwesome.location_arrow,
                            //             size: getProportionateScreenHeight(14),
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: SizedBox(
                            //             width: getProportionateScreenWidth(5),
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: GestureDetector(
                            //             onTap: () {
                            //               Navigator.pushNamed(
                            //                   context, BranchScreen.routeName,
                            //                   arguments: discount);
                            //             },
                            //             child: NormalText(
                            //               fontSize:
                            //                   getProportionateScreenHeight(14),
                            //               text: "Location",
                            //               textColor: Colors.black,
                            //               isUnderlined: true,
                            //             ),
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: SizedBox(
                            //             width: getProportionateScreenWidth(30),
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: Icon(
                            //             FontAwesome.clock_o,
                            //             size: getProportionateScreenHeight(14),
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: SizedBox(
                            //             width: getProportionateScreenWidth(5),
                            //           ),
                            //         ),
                            //         WidgetSpan(
                            //           child: GestureDetector(
                            //             onTap: () {
                            //               openOperatingHoursDialog(
                            //                 discount: discount,
                            //               );
                            //             },
                            //             child: NormalText(
                            //               fontSize:
                            //                   getProportionateScreenHeight(14),
                            //               text: "Operating hours",
                            //               textColor: Colors.black,
                            //               isUnderlined: true,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            HeadingText(
                              text: 'Ingredients',
                              heading: 3,
                              textColor: Colors.black,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            NormalText(text: recipe.recipeIngredients),
                            // Html(
                            //   data: discount.description ?? 'No details.',
                            //   style: {
                            //     "html": Style(
                            //       fontSize: FontSize(
                            //         getProportionateScreenHeight(14),
                            //       ),
                            //     ),
                            //     "body": Style(
                            //         margin: EdgeInsets.zero,
                            //         padding: EdgeInsets.zero),
                            //   },
                            // ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            HeadingText(
                              text: 'Instructions',
                              heading: 3,
                              textColor: Colors.black,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            NormalText(text: recipe.recipeInstructions),
                            // Html(
                            //   data: discount.storeDescription ?? 'No details.',
                            //   style: {
                            //     "html": Style(
                            //       fontSize: FontSize(
                            //         getProportionateScreenHeight(14),
                            //       ),
                            //     ),
                            //     "body": Style(
                            //         margin: EdgeInsets.zero,
                            //         padding: EdgeInsets.zero),
                            //   },
                            // ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            HeadingText(
                              text: 'Video Tutorial',
                              heading: 3,
                              textColor: Colors.black,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchURL(recipe.recipeVideo.toString());
                              },
                              child: Text(
                                '${recipe.recipeVideo}',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            // Container(
                            //   // decoration: BoxDecoration(color: Colors.red),
                            //   child: Html(
                            //     data: discount.tnc,
                            //     style: {
                            //       "html": Style(
                            //         fontSize: FontSize(
                            //           getProportionateScreenHeight(14),
                            //         ),
                            //       ),
                            //       "body": Style(
                            //           margin: EdgeInsets.zero,
                            //           padding: EdgeInsets.zero),
                            //     },
                            //   ),
                            //   // NormalText(
                            //   //   text: discount.tnc,
                            //   //   fontSize: 12,
                            //   // ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: getProportionateScreenHeight(5),
            // ),
            // if (discount.redeemId != null)
            //   SafeArea(
            //     top: false,
            //     child: Container(
            //       padding: UgekPadding.commonPadding,
            //       child: DefaultButton(
            //         text: 'Redeemed',
            //         isPrimary: false,
            //         press: () {
            //           print('Redeemed');
            //           onRedeemed(discount: discount);
            //         },
            //       ),
            //     ),
            //   )
            // else if (discount.isAvailable && !discount.checkIfLimitExceeded())
            //   SafeArea(
            //     top: false,
            //     child: Container(
            //       padding: UgekPadding.commonPadding,
            //       child: DefaultButton(
            //         text: 'Redeem Now',
            //         isPrimary: true,
            //         press: () {
            //           print('Redeem Now');
            //           onRedeemNow(discount: discount);
            //         },
            //       ),
            //     ),
            //   )
            // else
            //   Container(
            //     decoration: BoxDecoration(
            //       color: Colors.red,
            //     ),
            //     width: double.infinity,
            //     child: SafeArea(
            //       top: false,
            //       child: NormalText(
            //         text: 'Discount currently is unavailable! \n(Out of stock)',
            //         textColor: Colors.white,
            //         align: TextAlign.center,
            //       ),
            //     ),
            //   )
          ],
        );
      })),
    );
  }
}

// class DiscountDetailDisplay extends HookConsumerWidget {
//   DiscountDetailDisplay({
//     Key? key,
//     required this.discountRedeemId,
//   }) : super(key: key);

//   final DiscountRedeemId discountRedeemId;

//   final CarouselController _controller = CarouselController();

//   final _current = useState<int>(0);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authControllerState = ref.watch(authControllerProvider);
//     final discountDetailControllerState =
//         ref.watch(discountDetailControllerProvider(discountRedeemId));

//     openOperatingHoursDialog({required Discount discount}) {
//       OperatingHoursDialog.show(
//         context: context,
//         discount: discount,
//       );
//     }

//     onRedeemNow({required Discount discount}) {
//       String _confirmTitle = 'Ready to redeem?';
//       if (discount.discountType == DiscountType.IN_STORE)
//         _confirmTitle = 'Ready to redeem in \n10 minutes?';

//       String _confirmDescription = 'This discount only allow one redemption.';
//       showConfirmDialog(
//         context: context,
//         backButtonLabel: 'Later',
//         confirmTitle: _confirmTitle,
//         confirmDescription: _confirmDescription,
//         confirmEvent: () async {
//           bool isRedeemed = false;
//           if (authControllerState.status == UserStatus.VERIFIED) {
//             //TODO: handle out of stock
//             isRedeemed = await ref
//                 .read(
//                     discountDetailControllerProvider(discountRedeemId).notifier)
//                 .redeemDiscount();
//             if (isRedeemed)
//               //show redeem result
//               RedeemDialog.show(
//                 context: context,
//                 discountRedeemId: discountRedeemId,
//                 status: authControllerState.status,
//                 type: discount.discountType,
//               );
//           } else
//             //prompt user to verify
//             RedeemDialog.show(
//               context: context,
//               discountRedeemId: discountRedeemId,
//               status: authControllerState.status,
//               type: discount.discountType,
//             );
//         },
//       );
//     }

//     onRedeemed({required Discount discount}) {
//       // print(discount.isClaimed);
//       // if (discount.isClaimed) {

//       if (discount.discountType == DiscountType.ONLINE) {
//         // print(discount.code);
//         RedeemDialog.show(
//           context: context,
//           discountRedeemId: discountRedeemId,
//           status: authControllerState.status,
//           type: discount.discountType,
//         );
//       } else {
//         null;
//       }
//     }

//     return discountDetailControllerState.when(
//       data: (discount) => Column(
//         children: [
//           Container(
//             child: Expanded(
//               child: SingleChildScrollView(
//                 physics: ClampingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         discount.gallery == null
//                             ? CustomCachedNetworkImage(
//                                 boxfit: BoxFit.contain,
//                                 image:
//                                     'https://ksyong.s3.ap-southeast-1.amazonaws.com/ugek-logo.png',
//                               )
//                             : CarouselSlider(
//                                 carouselController: _controller,
//                                 options: CarouselOptions(
//                                     // height: 400,
//                                     aspectRatio: 16 / 9,
//                                     viewportFraction: 1,
//                                     initialPage: 0,
//                                     // reverse: false,
//                                     scrollDirection: Axis.horizontal,
//                                     onPageChanged: (index, reason) {
//                                       _current.value = index;
//                                     }),
//                                 items: discount.gallery!.map((item) {
//                                   return Builder(
//                                     builder: (BuildContext context) {
//                                       return CustomCachedNetworkImage(
//                                           image: item);
//                                     },
//                                   );
//                                 }).toList(),
//                               ),
//                         Positioned.fill(
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Container(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: discount.gallery!
//                                     .asMap()
//                                     .entries
//                                     .map((entry) {
//                                   return Container(
//                                     width: 8.0,
//                                     height: 8.0,
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 4.0),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: (Theme.of(context).brightness ==
//                                                   Brightness.dark
//                                               ? Colors.white
//                                               : Colors.black)
//                                           .withOpacity(
//                                               _current.value == entry.key
//                                                   ? 0.8
//                                                   : 0.2),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // SizedBox(height: getProportionateScreenHeight(20)),
//                     Container(
//                       padding: UgekPadding.postDetailPaddingTitle,
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: getProportionateScreenHeight(10),
//                               ),
//                               width: getProportionateScreenWidth(80),
//                               child: Divider(
//                                 thickness: 3,
//                                 color: UgekColors.kPrimaryColor,
//                               ),
//                             ),
//                           ),
//                           HeadingText(
//                             text: discount.storeName,
//                             heading: 3,
//                             textColor: UgekColors.kPrimaryColor,
//                           ),
//                           HeadingText(
//                             text: "${discount.title}",
//                             heading: 2,
//                             textColor: Colors.black,
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(20),
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Expanded(
//                                 flex: 7,
//                                 child: Container(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       IconTextWidget(
//                                         icon: FontAwesome.calendar,
//                                         text:
//                                             "Valid until ${reformatDate(date: discount.expiryDate)}",
//                                       ),
//                                       SizedBox(
//                                           height:
//                                               getProportionateScreenHeight(5)),
//                                       DetailsTagsWidget(
//                                         tags: [
//                                           "${DiscountType.toReadableText(discount.discountType)}",
//                                           if (!discount.halal &&
//                                               discount.storeCategory == 'F&B')
//                                             "Non-Halal",
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 3,
//                                 child: Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       if (discount.whatsapp != null)
//                                         if (discount.whatsapp!.length > 0)
//                                           DefaultIconButton(
//                                             size: 25,
//                                             icon: UgekIcons.whatapps,
//                                             press: () {
//                                               launchWhatsApp(
//                                                   hpNumber: discount.whatsapp!);
//                                             },
//                                           ),
//                                       DefaultIconButton(
//                                         size: 25,
//                                         icon: discount.isSaved
//                                             ? UgekIcons.liked
//                                             : UgekIcons.unliked,
//                                         press: () async {
//                                           await ref
//                                               .read(
//                                                   discountDetailControllerProvider(
//                                                           discountRedeemId)
//                                                       .notifier)
//                                               .saveDiscount(
//                                                   savedDiscount:
//                                                       discount.copyWith(
//                                                           isSaved: !discount
//                                                               .isSaved));
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             thickness: 1,
//                             color: Colors.black,
//                             height: getProportionateScreenHeight(30),
//                           ),
//                           if (discount.discountType == DiscountType.IN_STORE)
//                             Text.rich(
//                               TextSpan(
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                 ),
//                                 children: [
//                                   WidgetSpan(
//                                     child: Icon(
//                                       FontAwesome.location_arrow,
//                                       size: getProportionateScreenHeight(14),
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: SizedBox(
//                                       width: getProportionateScreenWidth(5),
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.pushNamed(
//                                             context, BranchScreen.routeName,
//                                             arguments: discount);
//                                       },
//                                       child: NormalText(
//                                         fontSize:
//                                             getProportionateScreenHeight(14),
//                                         text: "Location",
//                                         textColor: Colors.black,
//                                         isUnderlined: true,
//                                       ),
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: SizedBox(
//                                       width: getProportionateScreenWidth(30),
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: Icon(
//                                       FontAwesome.clock_o,
//                                       size: getProportionateScreenHeight(14),
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: SizedBox(
//                                       width: getProportionateScreenWidth(5),
//                                     ),
//                                   ),
//                                   WidgetSpan(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         openOperatingHoursDialog(
//                                           discount: discount,
//                                         );
//                                       },
//                                       child: NormalText(
//                                         fontSize:
//                                             getProportionateScreenHeight(14),
//                                         text: "Operating hours",
//                                         textColor: Colors.black,
//                                         isUnderlined: true,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(10),
//                           ),
//                           HeadingText(
//                             text: 'Description',
//                             heading: 3,
//                             textColor: Colors.black,
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(5),
//                           ),
//                           Html(
//                             data: discount.description ?? 'No details.',
//                             style: {
//                               "html": Style(
//                                 fontSize: FontSize(
//                                   getProportionateScreenHeight(14),
//                                 ),
//                               ),
//                               "body": Style(
//                                   margin: EdgeInsets.zero,
//                                   padding: EdgeInsets.zero),
//                             },
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(10),
//                           ),
//                           HeadingText(
//                             text: 'About Us',
//                             heading: 3,
//                             textColor: Colors.black,
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(5),
//                           ),
//                           Html(
//                             data: discount.storeDescription ?? 'No details.',
//                             style: {
//                               "html": Style(
//                                 fontSize: FontSize(
//                                   getProportionateScreenHeight(14),
//                                 ),
//                               ),
//                               "body": Style(
//                                   margin: EdgeInsets.zero,
//                                   padding: EdgeInsets.zero),
//                             },
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(10),
//                           ),
//                           HeadingText(
//                             text: 'Terms and Conditions',
//                             heading: 3,
//                             textColor: Colors.black,
//                           ),
//                           SizedBox(
//                             height: getProportionateScreenHeight(5),
//                           ),
//                           Container(
//                             // decoration: BoxDecoration(color: Colors.red),
//                             child: Html(
//                               data: discount.tnc,
//                               style: {
//                                 "html": Style(
//                                   fontSize: FontSize(
//                                     getProportionateScreenHeight(14),
//                                   ),
//                                 ),
//                                 "body": Style(
//                                     margin: EdgeInsets.zero,
//                                     padding: EdgeInsets.zero),
//                               },
//                             ),
//                             // NormalText(
//                             //   text: discount.tnc,
//                             //   fontSize: 12,
//                             // ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: getProportionateScreenHeight(5),
//           ),
//           if (discount.redeemId != null)
//             SafeArea(
//               top: false,
//               child: Container(
//                 padding: UgekPadding.commonPadding,
//                 child: DefaultButton(
//                   text: 'Redeemed',
//                   isPrimary: false,
//                   press: () {
//                     print('Redeemed');
//                     onRedeemed(discount: discount);
//                   },
//                 ),
//               ),
//             )
//           else if (discount.isAvailable && !discount.checkIfLimitExceeded())
//             SafeArea(
//               top: false,
//               child: Container(
//                 padding: UgekPadding.commonPadding,
//                 child: DefaultButton(
//                   text: 'Redeem Now',
//                   isPrimary: true,
//                   press: () {
//                     print('Redeem Now');
//                     onRedeemNow(discount: discount);
//                   },
//                 ),
//               ),
//             )
//           else
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//               ),
//               width: double.infinity,
//               child: SafeArea(
//                 top: false,
//                 child: NormalText(
//                   text: 'Discount currently is unavailable! \n(Out of stock)',
//                   textColor: Colors.white,
//                   align: TextAlign.center,
//                 ),
//               ),
//             )
//         ],
//       ),
//       loading: () => Center(
//         child: CircularProgressIndicator(),
//       ),
//       error: (error, _) => Center(
//         child: NormalText(
//           text: 'Ooops! Something went wrong. \nPlease try again later!',
//           align: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
