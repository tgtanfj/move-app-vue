import 'package:move_app/data/models/category_model.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: 1,
    title: 'Category 1',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 0,
  ),
  CategoryModel(
    id: 2,
    title: 'Category 2',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 2200000,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
  CategoryModel(
    id: 4,
    title: 'Category 4',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 0,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
  CategoryModel(
    id: 3,
    title: 'Category 3',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
    numberOfViews: 10000,
  ),
];

// TODO: Remove this dummy data
final List<NotificationModel> notifications = [
  NotificationModel(
    id: 1,
    userModel: UserModel(
        username: 'than.am.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2Ff9a076ae-629c-49ab-9ef8-84a5932dd38e?alt=media&token=395521bc-f5ca-4a14-ad52-d15d48054a42"),
    content: 'reply your comment.',
    createTime: '1 mins ago',
    videoId: 1,
    hasRead: false,
  ),
  NotificationModel(
    id: 2,
    userModel: UserModel(
        username: 'ngoc.gian.03',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F4ea711c6-eb45-43a6-b171-197499a91ede?alt=media&token=63d6d6cb-4d52-4d98-88e6-1fc021bc68b8"),
    content: ' liked your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tran.dan.043',),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 4,
    userModel: UserModel(
        username: 'dane.nguyen.0309',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F9c650c26-bc1e-47e1-a49c-0c532c1c4624.jpg?alt=media&token=c9fa22f2-4bce-461e-833d-af2ae8a32cd0"),
    content: ' reply your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tuan.doan.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdavid.wilson%40example.com%2F783c818e-da39-442d-bf28-18431d0de966?alt=media&token=e7820b80-4d25-4748-9a72-3e8c49fcc580"),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 1,
    userModel: UserModel(
        username: 'than.am.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2Ff9a076ae-629c-49ab-9ef8-84a5932dd38e?alt=media&token=395521bc-f5ca-4a14-ad52-d15d48054a42"),
    content: 'reply your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 2,
    userModel: UserModel(
        username: 'ngoc.gian.03',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F4ea711c6-eb45-43a6-b171-197499a91ede?alt=media&token=63d6d6cb-4d52-4d98-88e6-1fc021bc68b8"),
    content: ' liked your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tran.dan.043',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdavid.wilson%40example.com%2F332636819_5865095220248489_6948307745297316759_n.jpg?alt=media&token=e165cfa8-b1eb-4096-9756-9456ba074718"),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 4,
    userModel: UserModel(
        username: 'dane.nguyen.0309',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F9c650c26-bc1e-47e1-a49c-0c532c1c4624.jpg?alt=media&token=c9fa22f2-4bce-461e-833d-af2ae8a32cd0"),
    content: ' reply your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tuan.doan.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdavid.wilson%40example.com%2F783c818e-da39-442d-bf28-18431d0de966?alt=media&token=e7820b80-4d25-4748-9a72-3e8c49fcc580"),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 1,
    userModel: UserModel(
        username: 'than.am.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2Ff9a076ae-629c-49ab-9ef8-84a5932dd38e?alt=media&token=395521bc-f5ca-4a14-ad52-d15d48054a42"),
    content: 'reply your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 2,
    userModel: UserModel(
        username: 'ngoc.gian.03',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F4ea711c6-eb45-43a6-b171-197499a91ede?alt=media&token=63d6d6cb-4d52-4d98-88e6-1fc021bc68b8"),
    content: ' liked your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tran.dan.043',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdavid.wilson%40example.com%2F332636819_5865095220248489_6948307745297316759_n.jpg?alt=media&token=e165cfa8-b1eb-4096-9756-9456ba074718"),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 4,
    userModel: UserModel(
        username: 'dane.nguyen.0309',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdatlowashere%40gmail.com%20%2F9c650c26-bc1e-47e1-a49c-0c532c1c4624.jpg?alt=media&token=c9fa22f2-4bce-461e-833d-af2ae8a32cd0"),
    content: ' reply your comment.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
  NotificationModel(
    id: 3,
    userModel: UserModel(
        username: 'tuan.doan.01',
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/r-coffee-ee438.appspot.com/o/images%2Fdavid.wilson%40example.com%2F783c818e-da39-442d-bf28-18431d0de966?alt=media&token=e7820b80-4d25-4748-9a72-3e8c49fcc580"),
    content: ' started following you.',
    createTime: '1 mins ago',
    hasRead: false,
  ),
];
