import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuse_connect/fuse_connect.dart';
import 'package:fuse_connect_example/constants/colors.dart';
import 'package:fuse_connect_example/utils/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary[50],
        leading: Container(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/features/home/profile_picture.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.bell,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/features/home/virtual_card.png',
            ),
            balanceCashbackSection(),
            const SizedBox(
              height: 20,
            ),
            benefitsSection(),
          ],
        ),
      ),
    );
  }

  Container balanceCashbackSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: section(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Card balance',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '\$0.00',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final clientSecret = await API.createSession(
                                phone: "+14088194599",
                                template: "BankLinking",
                              );

                              final fuseConnect = FuseConnect(
                                onSuccess: (publicToken) async {
                                  if (kDebugMode) {
                                    print('Public token dart $publicToken');
                                  }

                                  String accessToken = "";
                                  try {
                                    accessToken = await API.exchangePublicToken(
                                        publicToken: publicToken);
                                  } catch (e) {
                                    print('Could not get access token');
                                  }

                                  print('Access token $accessToken');

                                  if (kDebugMode) {
                                    print("On success");
                                  }
                                  if (!mounted) return;

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const HomePage(),
                                  ));
                                },
                                onExit: (error) {
                                  if (kDebugMode) {
                                    print("On exit");
                                  }
                                },
                                onInstitutionSelected:
                                    (String institutionId, callBack) async {
                                  String linkToken = await API.createLinkToken(
                                    institutionId: institutionId,
                                    userId: "138239374",
                                    clientSecret: clientSecret,
                                  );

                                  print('Link token $linkToken');

                                  callBack(linkToken);
                                },
                              );

                              fuseConnect.open(clientSecret);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add money',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: section(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Weekly activity',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '+\$0.00 cashback',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Image.asset(
                          'assets/images/features/home/cashback_graph.png',
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget benefitsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your card benefits",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                benefitTile(
                  assetPath: "assets/images/features/home/restaurant_icon.png",
                  title: '5% back',
                  subtitle: "at restaurants",
                ),
                benefitTile(
                  assetPath: "assets/images/features/home/restaurant_icon.png",
                  title: '5% back',
                  subtitle: "at restaurants",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  benefitTile({
    required String assetPath,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: AppColors.primary[50],
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            assetPath,
          ),
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget section({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
