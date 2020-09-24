import 'package:covid_19_app/screens/requirements/info_screen.dart';
import 'package:flutter/material.dart';

class SecureTransit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = new TextStyle(
        fontSize: 20.0,
        fontFamily: "Hind",
        fontWeight: FontWeight.bold,
        color: Color(0xff0066d0));

    var datos = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new SizedBox(
          height: 50.0,
        ),
        createBodyText(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas faucibus eros augue, nec lacinia augue lobortis ac. Suspendisse id magna eros. Phasellus tincidunt auctor dui et accumsan. Quisque condimentum dolor ac lobortis placerat. In vel lectus in ante tincidunt fringilla. Maecenas in augue laoreet, gravida odio id, facilisis magna. Phasellus auctor pretium ligula, sit amet feugiat nulla. Suspendisse vel ante vulputate, efficitur mi eget, convallis velit. Phasellus vitae facilisis eros. Proin eu odio sed enim placerat interdum ut sed libero. Suspendisse porta ullamcorper elementum. Maecenas lacinia purus eu turpis fermentum commodo. Morbi non libero a est auctor fringilla. Fusce dapibus, tortor et malesuada gravida, nisi lacus elementum enim, ut facilisis dolor sapien id leo. Sed condimentum velit ut urna sodales, sit amet condimentum ex iaculis. Nullam vitae nulla sit amet neque semper sagittis quis et risus."),
        new SizedBox(
          height: 30.0,
        ),
        createBodyText(
            "Sed interdum malesuada ante, id hendrerit velit tempus id. Donec rutrum dolor nec purus sodales, at consectetur elit tincidunt. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vel tempor ipsum. Vivamus eget justo imperdiet metus maximus iaculis vitae et ex. Sed tincidunt condimentum metus sit amet porta. Mauris eleifend sed magna vel ultricies. Nulla facilisis mi dignissim finibus eleifend. Vestibulum eget maximus mauris, at porta dui. Suspendisse potenti. Duis at erat arcu. Interdum et malesuada fames ac ante ipsum primis in faucibus. In ut euismod tellus, quis feugiat eros. Aliquam ultrices sem felis, quis elementum nisl eleifend suscipit."),
        new SizedBox(
          height: 30.0,
        ),
        createBodyText(
            "Quisque viverra finibus erat, nec ornare tortor placerat porta. Praesent vehicula ipsum nisi, sagittis varius lectus laoreet quis. Vestibulum sed justo congue, efficitur magna non, ultricies nisl. Integer ac nulla dui. Pellentesque pretium efficitur lorem quis vestibulum. Nulla dignissim vitae ligula lacinia mollis. Phasellus rutrum posuere pretium. Ut porttitor aliquet dolor, a faucibus lacus mattis nec. Phasellus ligula nibh, tristique quis magna non, consequat vulputate enim. Nullam varius lobortis auctor. Sed iaculis eget lacus id accumsan. Donec sagittis, ante et tempus blandit, libero erat consectetur nisi, non congue diam dui vitae dolor. Maecenas scelerisque sit amet mauris sed ultricies. Donec eu porta odio. Proin a purus vehicula, ullamcorper quam ut, posuere tortor."),
        new SizedBox(
          height: 30.0,
        ),
      ],
    );

    return InfoScreen("Tránsito seguro", datos);
  }

  createBodyText(String text) {
    return new Text(
      text,
      style: new TextStyle(fontSize: 15.0, color: Color(0xff0066d0)),
      textAlign: TextAlign.justify,
    );
  }
}
