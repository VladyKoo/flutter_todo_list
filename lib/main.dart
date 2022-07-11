import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do-List', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class TodoItem {
  String title;
  String id;
  bool checked;

  TodoItem(this.id, this.title, this.checked);
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todoList = <TodoItem>[
    TodoItem('aaa', 'todo1', false),
    TodoItem('bbb', 'todo2', false)
  ];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  hintText: 'Add new item',
                  suffixIcon: IconButton(
                    onPressed: _addItem,
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_getItems(false)),
          ),
          SliverToBoxAdapter(
            child: _todoList.length > 0
                ? Divider(
                    color: Colors.black,
                    thickness: 2,
                  )
                : null,
          ),
          SliverList(
            delegate: SliverChildListDelegate(_getItems(true)),
          )
        ],
      ),
    );
  }

  void _addItem() {
    if (_textFieldController.text.isNotEmpty) {
      String id = Random().nextDouble().toString();
      TodoItem item = TodoItem(id, _textFieldController.text, false);
      setState(() {
        _todoList.add(item);
      });
      _textFieldController.clear();
    } else
      print('empty');
  }

  List<Widget> _getItems([checked]) {
    final List<Widget> _todoWidgets = <Widget>[];
    for (TodoItem item in _todoList) {
      if (checked == null) {
        _todoWidgets.add(_buildTodoItem(item));
      } else {
        if (item.checked == checked) {
          _todoWidgets.add(_buildTodoItem(item));
        }
      }
    }
    return _todoWidgets;
  }

  Widget _buildTodoItem(TodoItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Checkbox(
                value: item.checked,
                onChanged: (value) {
                  _changeItem(item, value);
                },
              ),
              Text(
                item.title,
                style: TextStyle(
                    fontSize: 20,
                    decoration:
                        item.checked ? TextDecoration.lineThrough : null),
              ),
            ],
          ),
        ),
        IconButton(onPressed: () => _deleteItem(item), icon: Icon(Icons.close))
      ],
    );
  }

  void _changeItem(TodoItem item, val) {
    setState(() {
      _todoList.forEach((el) {
        if (el.id == item.id) {
          el.checked = val;
        }
      });
    });
  }

  void _deleteItem(TodoItem item) {
    setState(() {
      _todoList.removeWhere((el) => el.id == item.id);
    });
  }
}
