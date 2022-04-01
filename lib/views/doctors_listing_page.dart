import 'package:assignment1/base_classes/base_text.dart';
import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/constants/image_constant.dart';
import 'package:assignment1/models/doctor_model.dart';
import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/api_manager.dart';
import 'package:assignment1/utilities/managers/font_enum.dart';
import 'package:assignment1/views/doctor_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DoctorsListingPage extends StatefulWidget {
  const DoctorsListingPage({Key? key}) : super(key: key);

  @override
  State<DoctorsListingPage> createState() => _DoctorsListingPageState();
}

class _DoctorsListingPageState extends State<DoctorsListingPage> with SingleTickerProviderStateMixin {

  bool isGrid = false;
  late AnimationController _animationController;
  late Animation<Color?> _animateColor;
  late Animation<double> _animateIcon;
  final Curve _curve = Curves.easeOut;

  List<DoctorModel> listDoctorModel = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: ColorConst.primaryDark,
      end: ColorConst.primaryDark,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    super.initState();
    prepareDoctorListingData();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isGrid) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isGrid = !isGrid;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.list_view,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: toggle(),
      appBar: AppBar(
        backgroundColor: ColorConst.white,
        title: GeneralUtility.shared.getAssetImage(name: ImageConst.icDoctorBima, height: 50, fit: BoxFit.fitHeight),
        actions: [
          GeneralUtility.shared.getAssetImage(name: ImageConst.icBimaLogo)
        ],
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.menu),
          color: ColorConst.primary,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConst.white,
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: (){
            prepareDoctorListingData(showProcessing: false, completion: (){
              _refreshController.refreshCompleted();
            });
          },
          header: const MaterialClassicHeader(color: ColorConst.primary),
          child: (isGrid) ? getGridView() : getListView(),
        ),
      ),
    );
  }
}

extension on _DoctorsListingPageState {

  Widget getListView() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: listDoctorModel.length,
      itemBuilder: (buildContext, index){
        return getListCellView(listDoctorModel[index]);
      },
      separatorBuilder: (buildContext, index){
        return const Divider(height: 1, color: ColorConst.grey);
      },
    );
  }

  getListCellView(DoctorModel model) {
    return InkWell(
      onTap: (){
        GeneralUtility.shared.push(context, DoctorDetailPage(model.copy()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: 90,
        width: GeneralUtility.shared.getScreenSize(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConst.grey, width: 1),
                  borderRadius: BorderRadius.circular(25)
              ),
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GeneralUtility.shared.getNetworkImage(url: model.profilePic, fit: BoxFit.fill)
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(textAlignment: TextAlign.left, text: model.fullName, color: ColorConst.primary, myFont: MyFont.rBold, fontSize: 17,),
                  const SizedBox(height: 5),
                  BaseText(textAlignment: TextAlign.left, text: model.specialization?.toUpperCase() ?? "", color: ColorConst.primary, fontSize: 15,),
                  const SizedBox(height: 5),
                  BaseText(textAlignment: TextAlign.left, text: model.description ?? "", color: ColorConst.grey, textOverflow: TextOverflow.ellipsis, numberOfLines: 2, fontSize: 14,),
                ],
              ),
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }

}

extension on _DoctorsListingPageState {

  Widget getGridView() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.25, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: listDoctorModel.length,
        itemBuilder: (buildContext, index){
          return getGridCellView(listDoctorModel[index]);
        }
    );
  }

  getGridCellView(DoctorModel model) {
    return InkWell(
      onTap: (){
        GeneralUtility.shared.push(context, DoctorDetailPage(model.copy()));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorConst.grey, width: 1),
            borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 90,
        width: GeneralUtility.shared.getScreenSize(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConst.grey, width: 1),
                  borderRadius: BorderRadius.circular(25)
              ),
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GeneralUtility.shared.getNetworkImage(url: model.profilePic, fit: BoxFit.fill)
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(textAlignment: TextAlign.center, text: model.fullName, color: ColorConst.primary, myFont: MyFont.rBold, fontSize: 17,),
                  const SizedBox(height: 5),
                  BaseText(textAlignment: TextAlign.center, text: model.specialization?.toUpperCase() ?? "", color: ColorConst.primary, fontSize: 15,),
                  const SizedBox(height: 5),
                  BaseText(textAlignment: TextAlign.justify, text: model.description ?? "", color: ColorConst.grey, textOverflow: TextOverflow.ellipsis, numberOfLines: 5, fontSize: 14,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

extension on _DoctorsListingPageState {

  prepareDoctorListingData({bool showProcessing = true, void Function()? completion}) {
    if(showProcessing){
      GeneralUtility.shared.showProcessing();
    }
    APIManager.shared.performCall(api: API.getDoctors, completion: (status, message, response){
      List<dynamic> list = response;
      listDoctorModel = list.map((e) => DoctorModel.fromJson(e)).toList();
      listDoctorModel.sort((model1, model2) {
        return (model2.rating?.toDouble() ?? 0).compareTo((model1.rating?.toDouble() ?? 0));
      });
      setState(() {});
      if(showProcessing) {
        GeneralUtility.shared.hideProcessing();
      }
      if (completion != null) {
        completion();
      }
    });
  }

}