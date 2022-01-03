import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_crypto/pickfilehash.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Firebase Upload';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.green),
    home: const MainPage(),
  );
}


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {


    void openFiles(List<FileSystemEntity> files){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>
              FilesPage(file: files,)
          ));
    }

    return  Scaffold(
      appBar: AppBar(title: const Text('File Picker'),centerTitle: true,),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            ElevatedButton(onPressed: ()async {

              final result = await FilePicker.platform.pickFiles();
              if(result == null)return;
              final file = result.files.first;
              // openFile(file);

              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      PickedFileHash(file: file.path.toString(),name: file.name,)
                  ));


            },
            child: const Text('Pick file'),),
            const SizedBox(height: 25,),

            ElevatedButton(onPressed: ()async{
              final ImagePicker _picker = ImagePicker();
              // Capture a photo
              final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
              String path = photo!.path;
              String name = p.basename(photo.path);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      PickedFileHash(file: path,name:name ,)
                  ));
              },
              child: const Text('Take Picture'),),

            const SizedBox(height: 25,),

            ElevatedButton(onPressed: ()async {

              final appStorage = await getApplicationDocumentsDirectory();
              List<FileSystemEntity>? files = appStorage.listSync();
              openFiles(files);
            },
              child: const Text('Saved Files'),),
          ],
        ),
      ),
    );

  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}



class FilesPage extends StatefulWidget {
  final List<FileSystemEntity> file;

  const FilesPage({Key? key, required this.file}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('All files'),),),
      body: Center(
        child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemCount: widget.file.length - 1,
            itemBuilder: (context, index) {
              final File file = File(widget.file[index + 1].path);
              return BuildFile(file: file);
            }


        ),
      ),
    );
  }
}


class BuildFile extends StatefulWidget {
  final File file;
  const BuildFile({Key? key, required this.file}) : super(key: key);

  @override
  _BuildFileState createState() => _BuildFileState();
}

class _BuildFileState extends State<BuildFile> {


  @override
  Widget build(BuildContext context) {
    final String name = p.basename(widget.file.path);

    return InkWell(
      onTap: ()=>
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>
              PickedFileHash(file: widget.file.path,name: p.basename(widget.file.path),)
          )),
      child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(
                alignment: Alignment.center,

                child: p.extension(widget.file.path) == '.jpg'||p.extension(widget.file.path) == '.png' ? Image.file(File(widget.file.path),):
                const Icon(
                  Icons.folder,
                  color: Colors.pink,
                  size: 50.0,
                ),

              ),),
              Text(name,style: const TextStyle(fontSize: 6),),

            ],
          )

      ),

    );
  }
}

