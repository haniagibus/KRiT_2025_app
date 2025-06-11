import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/widgets/element_icon.dart';
import 'dart:html' as html;

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  void _openLink(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme().backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Informacje o aplikacji',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text_primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 80.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logotyp-PG-i-WETI.jpg',
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Aplikację przygotowano w ramach studenckiego projektu grupowego realizowanego na Wydziale ETI Politechniki Gdańskiej.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.text_secondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Autorzy projektu:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAuthorCard(
                            name: 'Agnieszka Kulesz',
                            email: 's193461@student.pg.edu.pl',
                            linkedinUrl: 'https://www.linkedin.com/in/agnieszka-kulesz-8a3b8630b/',
                          ),
                          const SizedBox(height: 12),
                          _buildAuthorCard(
                            name: 'Hanna Gibus',
                            email: 's188974@student.pg.edu.pl',
                            linkedinUrl: 'https://www.linkedin.com/in/hania-gibus-a75063302/',
                          ),
                          const SizedBox(height: 12),
                          _buildAuthorCard(
                            name: 'Weronika Koterba',
                            email: 's193127@student.pg.edu.pl',
                            linkedinUrl: 'https://www.linkedin.com/in/weronika-koterba-896769313/',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorCard({
    required String name,
    required String email,
    required String linkedinUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.person, size: 32, color: AppColors.text_primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text_primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _openLink('mailto:$email'),
                    child: Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _openLink(linkedinUrl),
              child: Image.asset(
                'assets/images/linkedin.png',
                width: 32,
                height: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
