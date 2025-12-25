import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  // 預先寫好此頁面的路徑名稱並設為static，可直接從類別取用
  static const routeName = '/myStatefulWidget';

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // 建立一個controller來監聽TextInput輸入文字的變化（輸入或刪除）
  // 直接用controller來改變輸入框內容controller.text = 'DESIRED_VALUE'
  final TextEditingController _controller = TextEditingController();

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void dispose() {
    _controller.dispose(); // 在離開頁面、Widget被銷毀時，要記得將controller註銷
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('13'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('What number comes next in the sequence?'),
          const Text('1, 1, 2, 3, 5, 8...?'),
          TextField(
            controller: _controller, // 指派Controller給TextField
            onChanged: (String value) async { // 隨時監聽輸入文字的變化
              if (value != '13') {
                return;
              }
              await showDialog<void>(  // 若當下的輸入值是13，會跳出視窗提示
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('That is correct!'),
                    content: const Text('13 is the right answer.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            onSubmitted: (String value) async { // 觸發送出行為，會把文字長度印出來
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          //TextFormField是TextField和FormField功能的整合，可以直接在Form之中使用。
          // 額外包含了一些表單相關功能如：驗證規則(validator)、儲存時的行為(onSaved)
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
            validator: (value) {
              if (value == null || value.trim() == '') {
                return '此欄位為必填';
              }
              return null;
            },
            onSaved: (value) {
              print('onSaved!');
            },
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.amber[colorCodes[index]],
                  child: Center(child: Text('Entry ${entries[index]}')),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
          ),
        ],

      ),

    );
  }
}