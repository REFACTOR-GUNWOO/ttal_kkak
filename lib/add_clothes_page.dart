import 'package:flutter/material.dart';
import 'clothes.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddClothesPage extends StatefulWidget {
  @override
  _AddClothesPageState createState() => _AddClothesPageState();
}

class _AddClothesPageState extends State<AddClothesPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _primaryCategory = '상의';
  String _secondaryCategory = '티셔츠';
  Color _color = Colors.black;
  TopLength _topLength = TopLength.medium;
  SleeveLength _sleeveLength = SleeveLength.short;
  Neckline _neckline = Neckline.round;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Clothes newClothes = Clothes(
          id: 11,
          name: _name,
          primaryCategory: _primaryCategory,
          secondaryCategory: _secondaryCategory,
          details: ClothesDetails(
            topLength: _topLength,
            sleeveLength: _sleeveLength,
            neckline: _neckline,
          ),
          color: _color,
          regTs: DateTime.now());
      // Do something with newClothes, e.g., add to list or send to backend.
      Navigator.of(context).pop(newClothes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('옷 등록', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '옷 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '1차 카테고리'),
                value: _primaryCategory,
                onChanged: (value) {
                  setState(() {
                    _primaryCategory = value!;
                  });
                },
                items: ['상의', '하의', '아우터', '원피스']
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '2차 카테고리'),
                value: _secondaryCategory,
                onChanged: (value) {
                  setState(() {
                    _secondaryCategory = value!;
                  });
                },
                items: _getSecondaryCategories(_primaryCategory)
                    .map((subcategory) => DropdownMenuItem(
                        value: subcategory, child: Text(subcategory)))
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Text('색상 선택', style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () {
                  _showColorPicker(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  color: _color,
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<TopLength>(
                decoration: InputDecoration(labelText: '상의 길이'),
                value: _topLength,
                onChanged: (value) {
                  setState(() {
                    _topLength = value!;
                  });
                },
                items: TopLength.values
                    .map((length) => DropdownMenuItem(
                        value: length,
                        child: Text(length.toString().split('.').last)))
                    .toList(),
              ),
              DropdownButtonFormField<SleeveLength>(
                decoration: InputDecoration(labelText: '팔 길이'),
                value: _sleeveLength,
                onChanged: (value) {
                  setState(() {
                    _sleeveLength = value!;
                  });
                },
                items: SleeveLength.values
                    .map((length) => DropdownMenuItem(
                        value: length,
                        child: Text(length.toString().split('.').last)))
                    .toList(),
              ),
              DropdownButtonFormField<Neckline>(
                decoration: InputDecoration(labelText: '넥 라인'),
                value: _neckline,
                onChanged: (value) {
                  setState(() {
                    _neckline = value!;
                  });
                },
                items: Neckline.values
                    .map((line) => DropdownMenuItem(
                        value: line,
                        child: Text(line.toString().split('.').last)))
                    .toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getSecondaryCategories(String primaryCategory) {
    switch (primaryCategory) {
      case '상의':
        return ['티셔츠', '셔츠', '블라우스'];
      case '하의':
        return ['바지', '스커트'];
      case '아우터':
        return ['재킷', '코트'];
      case '원피스':
        return ['드레스'];
      default:
        return [];
    }
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = _color;
        return AlertDialog(
          title: Text('색상 선택'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _color = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('선택'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
