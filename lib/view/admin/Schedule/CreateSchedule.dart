import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:helbage/shared/_shared.dart';
import 'package:helbage/view/admin/Schedule/_schedule.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({Key? key}) : super(key: key);
  @override
  State<CreateSchedule> createState() => _CreateSchedule();
}

class _CreateSchedule extends State<CreateSchedule> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? state;
  String? time;
  final timeFormat = DateFormat("HH:mm");
  Validation validate = Validation();
  TextEditingController _cityField = TextEditingController();
  TextEditingController _timeField = TextEditingController();
  var platno;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateScheduleViewModel>.reactive(
        viewModelBuilder: () => CreateScheduleViewModel(),
        builder: (context, model, child) {
          if (!model.setup) {
            addNewRow(model);
            addNewRow(model);
            model.setup = true;
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: logoColor,
                // leading:Container(child:IconButton(icon:Icon(Icons.arrow_back),onPressed: (){model.quit();})),
                title: Text("Create New Schedule"),
                actions: [],
              ),
              body: SingleChildScrollView(
                  child: Form(
                      key: _formkey,
                      child: Center(
                          child: Column(children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(top: 30),
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width / 5,
                                child: Center(child: Text("Create Schedule"))),
                            Container(
                                padding: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width / 5,
                                child: getStateDropDownEnum(
                                    onChangeValue: (dynamic? value) {
                                      state = value;
                                    },
                                    value: state)),
                            TextinputForm(
                              "Path",
                              Colors.black,
                              Colors.white,
                              _cityField,
                              validator: validate.validateForEmpty,
                              inputype: TextInputType.text,
                              readonly: false,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start Time: "),
                                    Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        width: MediaQuery.of(context)
                                                .size
                                                .width -
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: DateTimeField(
                                            controller: _timeField,
                                            validator:
                                                validate.validateDateTime,
                                            format: timeFormat,
                                            onShowPicker:
                                                (context, currentValue) async {
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: 8, minute: 0),
                                              );

                                              return DateTimeField.convert(
                                                  time);
                                            })),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 5, 10),
                                          child: txtButton("Assign Vehicle",
                                              () async {
                                            platno = await showDialog<String>(
                                                context: context,
                                                builder: (context) =>
                                                    VehicleDialog());
                                          }, Colors.green, 140, 50, TextStyle(),
                                              radius: 0),
                                        ),
                                        platno == null
                                            ? Center()
                                            : Text(platno + " is selected")
                                      ],
                                    )
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Location'),
                                  Text('Duration  (in minute)')
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            children: model.InputList,
                          ),
                        ),
                        TextButton(
                            onPressed: () => {
                                  addNewRow(model),
                                  //model.addNewRow()
                                },
                            child: Text("Add New Row")),
                        TextButton(
                            onPressed: () => {model.deleteLastRow()},
                            child: Text("Delete Last Row")),
                        TextButton(
                            onPressed: () => {
                                  model.create(state, _cityField.text, _formkey,
                                      _timeField, platno)
                                },
                            child: Text("Create")),
                      ])))));
        });
  }

  addNewRow(model) {
    model.ControllerList.add(
        [TextEditingController(), TextEditingController()]);
    model.InputList.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      TextinputForm(
        "Location",
        Colors.black,
        Colors.white,
        model.ControllerList.last[0],
        validator: validate.validateForEmpty,
        inputype: TextInputType.text,
        widthRatio: 1.5,
        readonly: false,
      ),
      TextinputForm(
        "Duration",
        Colors.black,
        Colors.white,
        model.ControllerList.last[1],
        validator: validate.validateNumOnly,
        inputype: TextInputType.text,
        widthRatio: 1.5,
        readonly: false,
      ),
    ]));
    model.notifyListeners();
  }
}
