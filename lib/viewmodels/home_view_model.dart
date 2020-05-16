import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/models/route_argument.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/location_service.dart';
// import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocationService _locationService = locator<LocationService>();
  final APIService _apiService = locator<APIService>();
  // final DialogService _dialogService = locator<DialogService>();

  List<Post> _posts;
  List<Post> get posts => _posts;
  Future init() {
    // _locationService.getLocation();
    
    // _apiService.getProducts(); // -> Query from _locationServer
    // _apiService.getPromotions();
    // _apiService.getSellers();
    // _apiService.getSubCategories();

    return null;
  }

  Future deletePost(int index) async {
    // var dialogResponse = await _dialogService.showConfirmationDialog(
    //   title: 'Are you sure?',
    //   description: 'Do you really want to delete the post?',
    //   confirmationTitle: 'Yes',
    //   cancelTitle: 'No',
    // );

    // if (dialogResponse.confirmed) {
    //   var postToDelete = _posts[index];
    //   setBusy(true);
    //   await _apiService.deletePost(postToDelete.documentId);
    //   // Delete the image after the post is deleted
    //   await _cloudStorageService.deleteImage(postToDelete.imageFileName);
    //   setBusy(false);
    // }
  }

  Future<void> search() async {
    await _navigationService.navigateTo(SearchViewRoute);
  }

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Authtoken);
    prefs.remove(PhoneNo);
    await _navigationService.navigateReplaceTo(LoginViewRoute);
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Future openmap() async {
    await _navigationService.navigateTo(MapViewRoute);
  }

  void editPost(int index) {
    _navigationService.navigateTo(CreatePostViewRoute,
        arguments: _posts[index]);
  }
}
