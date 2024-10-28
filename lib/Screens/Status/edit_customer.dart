import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentel_round/Models/car_model.dart';
import 'package:rentel_round/Models/status_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcar_screen.dart';
import 'package:rentel_round/Screens/Customer/bottomsheetcar_tile.dart';
import 'package:rentel_round/Screens/Customer/customerFeilds.dart';
import 'package:rentel_round/Services/car_services.dart';
import 'package:rentel_round/Services/status_services.dart';

class EditScreenCustomer extends StatefulWidget {
  final status customer;
  const EditScreenCustomer({required this.customer, super.key});

  @override
  State<EditScreenCustomer> createState() => _EditScreenCustomerState();
}

class _EditScreenCustomerState extends State<EditScreenCustomer> {
  late DateTime dateNow;
  late DateTime lastdateTime;
  DateTime? displayDate;
  int? finalAmount;
  List<Cars> listCar = [];
  int? total = 0;
  TextEditingController cnameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noOfDaysController = TextEditingController();
  TextEditingController currentKmController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController extraAmtController = TextEditingController();
  List<String> month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  late Cars carSelected;
  final GlobalKey<FormState> _key = GlobalKey();
  CustomerFeilds customerFields = CustomerFeilds();
  ImagePicker picker = ImagePicker();
  XFile? proofImg;
  @override
  void initState() {
    _loadCars();
    amountController.addListener(_updateAmount);
    super.initState();
    cnameController = TextEditingController(text: widget.customer.cName);
    cidController = TextEditingController(text: widget.customer.cId);
    endDateController =
        TextEditingController(text: widget.customer.endDate.toString());
    amountController =
        TextEditingController(text: widget.customer.advAmount.toString());
    extraAmtController =
        TextEditingController(text: widget.customer.extraAmount.toString());
    dateNow = DateTime(widget.customer.startDate.year,
        widget.customer.startDate.month, widget.customer.startDate.day);
    lastdateTime = DateTime(widget.customer.endDate.year,
        widget.customer.endDate.month, widget.customer.endDate.day);
    carSelected = widget.customer.selectedCar;
    proofImg = XFile(widget.customer.proofImage);
    total = widget.customer.totalAmount;
  }

  void _loadCars() async {
    List<Cars> car = await CarServices().getAvailableCar();
    setState(() {
      listCar = car;
    });
  }

  void _updateAmount() {
    setState(() {});
  }

  void _editStatus(String customerID, status updatedStatus) async {
    await StatusServices().updateStatus(customerID, updatedStatus);
    _getStatus();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _getStatus() async {
    await StatusServices().getStatus();
    setState(() {});
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      proofImg = pickedImage;
    });
  }

  String? monthToWords(int value) {
    String? word;
    setState(() {
      word = month[value - 1];
    });
    return word;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    int noOfDays = lastdateTime.difference(dateNow).inDays;

    int hours = (lastdateTime.difference(dateNow).inHours);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.cName),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: kIsWeb ? screenWidth * 0.8 : null,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 130,
                          width: 130,
                          color: Colors.pink.shade50,
                          child: proofImg == null
                              ? Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      File(widget.customer.proofImage)))
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(proofImg!.path))),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(hours);
                              print(dateNow);
                              _pickImage();
                            },
                            child: const Text(
                              "UPLOAD",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "upload proof photo here",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  customerFields.fields(
                    (value) {
                      if (cnameController.text.isEmpty) {
                        return "Enter a Customer name";
                      }
                      return null;
                    },
                    "customer name",
                    "enter customer name",
                    cnameController,
                  ),
                  const SizedBox(height: 10),
                  customerFields.fields(
                    (value) {
                      if (cidController.text.isEmpty) {
                        return "Enter a Customer ID";
                      }
                      return null;
                    },
                    "customer ID",
                    "enter customer ID",
                    cidController,
                  ),
                  const SizedBox(height: 10),
                  customerFields.fieldsForAmt(
                    (value) {
                      if (amountController.text.isEmpty) {
                        return "Enter an amount";
                      }
                      return null;
                    },
                    "advanced amount",
                    "enter amount",
                    amountController,
                    TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  customerFields.fieldsForAmt(
                    (value) {
                      if (extraAmtController.text.isEmpty) {
                        return "Enter an amount";
                      }
                      return null;
                    },
                    "extra amount per 100 KM",
                    "enter amount",
                    extraAmtController,
                    TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewcarScreen(car: carSelected),
                              ));
                        },
                        child: BottomSheetCarTile(
                          carName: carSelected.carName,
                          vehicleNo: carSelected.vehicleNo,
                          kmDriven: carSelected.kmDriven,
                          seatCapacity: carSelected.seatCapacity,
                          cubicCapacity: carSelected.cubicCapacity,
                          rcNo: carSelected.rcNo,
                          pollutionDate: carSelected.pollutionDate,
                          fuelType: carSelected.fuelType,
                          amtPerDay: carSelected.amtPerDay,
                          carImage: carSelected.carImage,
                          brandName: carSelected.brandName,
                          carType: carSelected.carType,
                          pcImage: carSelected.pcImage,
                          rcImage: carSelected.rcImage,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Click to Extend End Date:"),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: Text(displayDate == null
                            ? "SELECT DATE"
                            : "${displayDate!.day}-${monthToWords(displayDate!.month)}-${displayDate!.year}"),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 250,
                                child: CupertinoDatePicker(
                                  minimumDate: dateNow.add(Duration(days: 1)),
                                  initialDateTime: lastdateTime,
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() {
                                      lastdateTime = newDate;
                                      displayDate = newDate;
                                      noOfDays = lastdateTime
                                          .difference(dateNow)
                                          .inDays;
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount:"),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        height: 80,
                        width: 250,
                        child: Center(
                          child: Text(
                            "₹ ${calculateTotal(noOfDays, amountController, carSelected)} for $noOfDays days",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showDialogue("Do you need to cancel edit?", "OK",
                              navigateToStatus, context);
                        },
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            if (proofImg == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Add Proof Image!")));
                              return;
                            }
                            _showDialogue("Click ok to save", "OK",
                                _editCustomer, context);
                          }
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editCustomer() async {
    status newStatus = status(
      cName: cnameController.text,
      cId: cidController.text,
      startDate: dateNow,
      endDate: lastdateTime,
      selectedCar: carSelected,
      advAmount: int.parse(amountController.text),
      extraAmount: int.parse(extraAmtController.text),
      proofImage: proofImg!.path,
      totalAmount: total!,
      amountReceived: 0,
    );
    _editStatus(cidController.text, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.blue,
        content: Text("Customer details edited!")));
  }

  Future<void> navigateToStatus() async {
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  int calculateTotal(
      int noOfDays, TextEditingController amountController, Cars? selectedCar) {
    if (amountController.text.isEmpty || selectedCar == null) {
      return 0;
    }

    int amtPerDay = selectedCar.amtPerDay;
    int total = (noOfDays * amtPerDay);

    return total;
  }

  void _showDialogue(String messege, String btnName, VoidCallback btnfn,
      BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(messege),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL")),
              ElevatedButton(onPressed: btnfn, child: Text(btnName))
            ],
          );
        });
  }
}
