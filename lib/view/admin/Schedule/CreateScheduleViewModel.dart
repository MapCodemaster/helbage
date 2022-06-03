import 'package:flutter/material.dart';
import 'package:helbage/app/route.locator.dart';
import 'package:helbage/app/route.router.dart';
import 'package:helbage/model/constant/State.dart';
import 'package:helbage/model/pathModel.dart';
import 'package:helbage/model/scheduleModel.dart';
import 'package:helbage/services/FirebaseServices/auth_service.dart';
import 'package:helbage/services/FirebaseServices/storage_service.dart';
import 'package:helbage/shared/textInputForm.dart';
import 'package:helbage/shared/validation.dart';
import 'package:helbage/view/admin/Schedule/VehicleDialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateScheduleViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final auth = locator<AuthService>();
  final stor = locator<storage_service>();

  List<Row> InputList = new List.empty(growable: true);

  List<List<TextEditingController>> ControllerList = List.empty(growable: true);

  Validation validate = Validation();
  CreateScheduleViewModel() {
    addNewRow();
    addNewRow();
  }

  void addNewRow() {
    ControllerList.add([TextEditingController(), TextEditingController()]);
    InputList.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      TextinputForm(
        "Location",
        Colors.black,
        Colors.white,
        ControllerList.last[0],
        validator: validate.validateForEmpty,
        inputype: TextInputType.text,
        widthRatio: 1.5,
      ),
      TextinputForm(
        "Duration",
        Colors.black,
        Colors.white,
        ControllerList.last[1],
        validator: validate.validateNumOnly,
        inputype: TextInputType.text,
        widthRatio: 1.5,
      ),
    ]));
    /*ControllerList.add(TextEditingController());
    InputList.add(
      TextinputForm(
                "City",
                Colors.black,
                Colors.white,
                ControllerList.last,
                validator: validate.validateForEmpty,
                inputype: TextInputType.text,
              )
    );*/
    notifyListeners();
  }

  Future<bool> create(state, city, _formkey, _timeField, platno) async {
    if (!_formkey.currentState!.validate()) {
      if (platno == null) {
        _dialogService.showDialog(title: "Vehicle is not assigned");
      }
      ;

      return false;
    } else {
      List<String> createLocationList = new List.empty(growable: true);
      List<String> createDurationList = new List.empty(growable: true);
      ControllerList.forEach((element) {
        createLocationList.add(element[0].text);
        createDurationList.add(element[1].text);
      });
      int index = 0;

      MalaysiaState.values.forEach((element) {
        if (element.name == state) {
          index = element.index;
          print(state);
        }
      });
      MalaysiaState s = MalaysiaState.values.elementAt(index);
      pathModel newPath = new pathModel.fromInput(
          startTimeString: _timeField.text,
          locationList: createLocationList,
          durationList: createDurationList,
          vehicle: platno);

      scheduleModel schedule = new scheduleModel(s, newPath, city);
      print(schedule.state);
      bool successInsert = await stor.insert(
          schedule.pathName,
          'schedule/' + schedule.state + "/Path",
          schedule.getPath().toFirestore());
      if (!successInsert) {
        _dialogService.showDialog(
            title: "Personal Information Error",
            description: "Error happen in registration, try again later",
            dialogPlatform: DialogPlatform.Material);
        return false;
      }

      _navigationService.back();
      return true;
    }
  }

  void quit() {
    _navigationService.navigateTo(Routes.viewSchedule);
  }

  void deleteLastRow() {
    if (InputList.length > 2) {
      ControllerList.removeLast();
      InputList.removeLast();
      notifyListeners();
    }
  }
}