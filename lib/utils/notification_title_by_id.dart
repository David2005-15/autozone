String notificationTitleById(String id) {
  switch (id) {
    case "open_door":
      return "Բաց է պատուհանը";
    case "disturb":
      return "Խանգարում է";
    case "acident":
      return "Վթարվել է";
    case "car_number":
      return "Գտել եմ";
    case "car_hit":
      return "Վնասել են";
    case "light_is_on":
      return "Միացված են";
    case "evacuation":
      return "Էվակուացնում են";
    case "closed_enterance":
      return "Փակել է";
    case _:
      return "";
  }
}

String notificationBodyById(String id, String number) {
  switch (id) {
    case "open_door":
      return "$number մեքենայի վարորդ, Ձեր մեքենայի պատուհանը բաց է։";
    case "disturb":
      return "$number մեքենայի վարորդ, Ձեր մեքենան փակել է իմ մեքենայի ճանապարհը։";
    case "acident":
      return "$number մեքենայի վարորդ, Ձեր մեքենան վթարվել է։";
    case "car_number":
      return "$number մեքենայի վարորդ, գտել եմ Ձեր մեքենայի համարանիշը։";
    case "car_hit":
      return "$number մեքենայի վարորդ, Ձեր մեքենան վնասել են։";
    case "light_is_on":
      return "$number մեքենայի վարորդ, Ձեր մեքենայի լուսարձակները միացված են։";
    case "evacuation":
      return "$number մեքենայի վարորդ, Ձեր մեքենան էվակուացնում են։";
    case "closed_enterance":
      return "$number մեքենայի վարորդ, Ձեր մեքենան փակել է իմ ավտոտնակի ճանապարհը։";
    case _:
      return "";
  }
}
