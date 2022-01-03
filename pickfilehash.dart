import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'main.dart';

class PickedFileHash extends StatelessWidget {
  final String file;
  final String name;


  const PickedFileHash({
    required this.file,
    required this.name,
    Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    final extension = p.extension(file);
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Test App'),),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
            extension == '.jpg'||extension == '.png'? SizedBox(height:300,child: Image.file(File(file))):
            const Icon(
              Icons.folder,
              color: Colors.pink,
              size: 50.0,
            ),
            const SizedBox(height: 16,),

            Center(child: Text(name),),
            const SizedBox(height: 16,),

            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()async {
                  final appStorage = await getApplicationDocumentsDirectory();
                  final newFile = File('${appStorage.path}/$name');

                  if(File('${appStorage.path}/$name').existsSync()){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) =>
                        const MainPage()
                        ));

                  }else{
                    File(file).copy(newFile.path);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) =>
                        const MainPage()
                        ));
                  }

                },
                  child: const Text('Save file'),),
                ElevatedButton(
                onPressed: (){
                  final File file1  = File(file);
                  var bytes = utf8.encode(file1.toString());
                  var digest = sha256.convert(bytes);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                          HashValue(value: digest.toString())
                      ));
                },

                    child: const Text('calculate hex value'))

              ],),
            ElevatedButton(
                onPressed: ()async{
                  final appStorage = await getApplicationDocumentsDirectory();
                  await File('${appStorage.path}/$name').delete();

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                      const MainPage()
                      ));
                },

                child: const Text('Delete file'))

          ],
        ),

      ),

    );
  }

}

class HashValue extends StatelessWidget {
  final String  value;
  const HashValue({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHA 256 hash value'),),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(value,style: const TextStyle(fontSize: 24),),),
    ),
    );
  }
}

