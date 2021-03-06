import 'package:helbage/model/guideLineModel.dart';
import 'package:helbage/view/admin/Guideline/AddGuidelineView.dart';
import 'package:helbage/view/admin/Guideline/singleGuidelineView.dart';
import 'package:helbage/view/resident/Guideline/singleGuideline.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:helbage/model/tagModel.dart';
import '../../../app/_route.dart';
import '../../../services/FirebaseServices/_services.dart';

class ViewGuidelineModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final stor = locator<storage_service>();
  List<tagModel> tagList = new List.empty(growable: true);
  List<guidelineModel> guidelineList = new List.empty(growable: true);
  var tagListener;
  bool status = false;
  bool selected = false;
  String? tag;
  ViewGuidelineModel() {
    status = true;
    getTag();
  }

  //read tag from firestore
  void getTag() async {
    tagList.clear();
    var db = await stor.readDocumentAsStream("guidelinetag", "summary");
    try {
      tagListener = db.listen((event) {});
      tagListener.onData((data) {
        tagList.clear();
        guidelineList.clear();
        getGuideline(tag);
        notifyListeners();
        //tagMap=data.get('tag');
        data.get('tag').keys.toList().forEach((item) {
          //tagList.add(new tagModel(name:item));

          tagList.add(new tagModel.withQuantity(
              name: item, quantity: data.get('tag')[item]));
        });
        sortTagList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //trigger after tag selected
  void getGuideline(value) async {
    status = false;
    notifyListeners();
    guidelineList.clear();

    tag = value.toString();
    var db = await stor.readCollectionAsStreamArrayCondition(
        'guideline', 'tag', value.toString());
    db.listen((event) {
      guidelineList.clear();
      notifyListeners();
    }).onData((data) {
      data.docs.forEach((element) {
        List<tagModel> tagList =
            guidelineModel.dynamicTagTotagModel(element['tag']);
        guidelineList.add(new guidelineModel.fromFireStore(
            docid: element.id,
            title: element['title'],
            content: element['content'],
            author: element['author'],
            tag: tagList,
            datetime: element['datetime'].toDate()));
      }); //End For each
      status = true;
      notifyListeners();
    });
  }

  @override
  void viewGuideline(element) {
    _navigationService.navigateToView(SingleGuideline(guideline: element));
  }

  void clearSelected() {
    selected = false;
    notifyListeners();
  }

  void sortTagList() async {
    if (tagList.length != 0) {
      tagList.sort((a, b) {
        if (a.quantity! > b.quantity!) {
          return 0;
        } else {
          return 1;
        }
      });
    }
  }
  void navigateToAdd()
  {
    _navigationService.navigateToView(AddGuidelineView(isAdmin: false));
  }
}
