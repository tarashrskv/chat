import 'package:chat/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close_rounded)),
              Text(
                'Створити чат',
                style: const TextStyle(fontSize: 22),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: Text('Ок'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 40,
                  maxLines: null,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelText: 'Заголовок',
                      helperMaxLines: 2,
                      helperText: 'Наприклад: поговорю про фільми, шукаю компанію, потрібна порада тощо.'
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLength: 100,
                  maxLines: null,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelText: 'Опис чату',
                      helperMaxLines: 2,
                      helperText: 'Можна вказати чим цікавишся, з ким хочеться поговорити або інші деталі.'
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'Твій вік',
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(child: TextFormField(
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'Твоя стать',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                      ),
                    ),),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                      labelText: true ? 'Введи регіон пошуку' : 'Регіон пошуку',
                      helperMaxLines: 2,
                      helperText: 'Назва твого міста або, наприклад, те, що ти в повній жопі.'
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Без обмежень'),
                  subtitle: Text(
                      'Позначай цей прапорець, якщо тема стосується інтиму, «вірту», відвертощів пікантного характеру, еротики, контенту «для дорослих», NSFW тощо.'),
                  value: true,
                  onChanged: (_) {},
                ),
                CheckboxListTile(
                  title: Text('Не впускати нових користувачів'),
                  subtitle: Text(
                      'Не впустить у твій діалог користувачів, які тільки-но завітали на сайт (менше 20хв тому). Допоможе, коли тебе атакують, обходячи блокування.'),
                  value: true,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}