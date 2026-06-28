import 'action_catalog.dart';

// Generated from 2. BRD/4.2 Cùng con.docx.
// The BRD action table contains code, triggers, and content. It does not
// contain a sub-tab column, so category is assigned deterministically by
// BRD order across Quan sát, Giao tiếp, and Hỗ trợ.
const defaultActionCatalog = <ActionCatalogItem>[
  ActionCatalogItem(
    code: "ACT_01",
    triggers: {"A1", "A2", "A3"},
    content:
        "Bố mẹ cùng con duy trì một hoạt động cả hai cùng thích để giữ kết nối tích cực.",
    category: "quan_sat",
    sortOrder: 1,
  ),
  ActionCatalogItem(
    code: "ACT_02",
    triggers: {"A1", "A2", "A3"},
    content:
        "Bố mẹ ghi nhận hoặc khen con vì những điều con đã cố gắng gần đây, dù là điều nhỏ.",
    category: "giao_tiep",
    sortOrder: 2,
  ),
  ActionCatalogItem(
    code: "ACT_03",
    triggers: {"A1", "A2", "A3"},
    content:
        "Bố mẹ cùng con trò chuyện ngắn về điều khiến hôm nay ổn hoặc dễ chịu hơn.",
    category: "ho_tro",
    sortOrder: 3,
  ),
  ActionCatalogItem(
    code: "ACT_04",
    triggers: {"A1", "A2", "A3"},
    content:
        "Gia đình cùng con lên kế hoạch cho một hoạt động nhỏ mà con mong chờ trong tuần tới.",
    category: "quan_sat",
    sortOrder: 4,
  ),
  ActionCatalogItem(
    code: "ACT_05",
    triggers: {"A1", "A2", "A3"},
    content:
        "Bố mẹ duy trì thói quen check-in để hiểu rõ hơn những thay đổi của con theo thời gian.",
    category: "giao_tiep",
    sortOrder: 5,
  ),
  ActionCatalogItem(
    code: "ACT_06",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng chơi môn thể thao vận động (cầu lông, đá bóng)",
    category: "ho_tro",
    sortOrder: 6,
  ),
  ActionCatalogItem(
    code: "ACT_07",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng chụp bộ ảnh kỷ niệm vui vẻ tại nhà",
    category: "quan_sat",
    sortOrder: 7,
  ),
  ActionCatalogItem(
    code: "ACT_08",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng thảo luận về một mục tiêu thú vị trong tương lai",
    category: "giao_tiep",
    sortOrder: 8,
  ),
  ActionCatalogItem(
    code: "ACT_09",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng nghe playlist nhạc yêu thích của con",
    category: "ho_tro",
    sortOrder: 9,
  ),
  ActionCatalogItem(
    code: "ACT_10",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng trang trí lại góc học tập theo ý con",
    category: "quan_sat",
    sortOrder: 10,
  ),
  ActionCatalogItem(
    code: "ACT_11",
    triggers: {"A1", "A2", "A3"},
    content: "Bố mẹ khen ngợi một nỗ lực nhỏ con làm trong ngày",
    category: "giao_tiep",
    sortOrder: 11,
  ),
  ActionCatalogItem(
    code: "ACT_12",
    triggers: {"A1", "A2", "A3"},
    content: "Bố mẹ chuẩn bị món ăn khoái khẩu để chúc mừng tinh thần con",
    category: "ho_tro",
    sortOrder: 12,
  ),
  ActionCatalogItem(
    code: "ACT_13",
    triggers: {"A1", "A2", "A3"},
    content: "Bố mẹ viết lời nhắn cổ vũ bỏ vào cặp sách cho con",
    category: "quan_sat",
    sortOrder: 13,
  ),
  ActionCatalogItem(
    code: "ACT_14",
    triggers: {"A1", "A2", "A3"},
    content: "Bố mẹ cho con quyền tự quyết định thực đơn bữa tối",
    category: "giao_tiep",
    sortOrder: 14,
  ),
  ActionCatalogItem(
    code: "ACT_15",
    triggers: {"A1", "A2", "A3"},
    content: "Bố mẹ nhờ con hướng dẫn làm một việc mà con giỏi",
    category: "ho_tro",
    sortOrder: 15,
  ),
  ActionCatalogItem(
    code: "ACT_16",
    triggers: {"A1", "A2", "A3"},
    content: "Cùng chơi một môn thể thao hoặc trò chơi vận động con thích.",
    category: "quan_sat",
    sortOrder: 16,
  ),
  ActionCatalogItem(
    code: "ACT_17",
    triggers: {"A1", "A2", "A3"},
    content:
        "Cùng thảo luận về một dự án hoặc ý tưởng mới mà con đang hào hứng.",
    category: "giao_tiep",
    sortOrder: 17,
  ),
  ActionCatalogItem(
    code: "ACT_18",
    triggers: {"A1", "A2", "A3"},
    content:
        "Khen ngợi cụ thể một nỗ lực hoặc điểm tích cực của con trong ngày.",
    category: "ho_tro",
    sortOrder: 18,
  ),
  ActionCatalogItem(
    code: "ACT_19",
    triggers: {"A1", "A2", "A3"},
    content:
        "Ghi lại khoảnh khắc vui vẻ của con (chụp ảnh, viết nhật ký gia đình).",
    category: "quan_sat",
    sortOrder: 19,
  ),
  ActionCatalogItem(
    code: "ACT_20",
    triggers: {"A4"},
    content:
        "Bố mẹ cùng con nghỉ màn hình khoảng 20–30 phút và chuyển sang hoạt động nhẹ nhàng hơn.",
    category: "giao_tiep",
    sortOrder: 20,
  ),
  ActionCatalogItem(
    code: "ACT_21",
    triggers: {"A4"},
    content:
        "Bố mẹ hoặc người thân cùng con đi bộ nhẹ, vận động ngắn hoặc thay đổi không gian để cơ thể có cơ hội lấy lại năng lượng.",
    category: "ho_tro",
    sortOrder: 21,
  ),
  ActionCatalogItem(
    code: "ACT_22",
    triggers: {"A4"},
    content:
        "Bố mẹ cùng con xem lại thời gian ngủ, nghỉ gần đây để điều chỉnh lịch sinh hoạt phù hợp hơn.",
    category: "quan_sat",
    sortOrder: 22,
  ),
  ActionCatalogItem(
    code: "ACT_23",
    triggers: {"A4"},
    content:
        "Bố mẹ chuẩn bị hoặc cùng con ăn một bữa nhẹ, uống đủ nước và nghỉ ngơi thêm nếu cần.",
    category: "giao_tiep",
    sortOrder: 23,
  ),
  ActionCatalogItem(
    code: "ACT_24",
    triggers: {"A4"},
    content:
        "Bố mẹ cân nhắc giảm bớt lịch quá dày hoặc tạo thêm khoảng nghỉ trong vài ngày tới cho con.",
    category: "ho_tro",
    sortOrder: 24,
  ),
  ActionCatalogItem(
    code: "ACT_25",
    triggers: {"A4", "A10"},
    content: "Cùng thực hành hít thở sâu theo nhịp 4-4-4",
    category: "quan_sat",
    sortOrder: 25,
  ),
  ActionCatalogItem(
    code: "ACT_26",
    triggers: {"A4", "A10"},
    content: "Cùng nghe nhạc sóng não hoặc âm thanh thiên nhiên",
    category: "giao_tiep",
    sortOrder: 26,
  ),
  ActionCatalogItem(
    code: "ACT_27",
    triggers: {"A4", "A10"},
    content: "Cùng đi ngủ sớm hơn thường lệ 30 phút",
    category: "ho_tro",
    sortOrder: 27,
  ),
  ActionCatalogItem(
    code: "ACT_28",
    triggers: {"A4", "A10"},
    content: "Cùng thực hiện bài tập giãn cơ nhẹ nhàng",
    category: "quan_sat",
    sortOrder: 28,
  ),
  ActionCatalogItem(
    code: "ACT_29",
    triggers: {"A4", "A10"},
    content: "Cùng ngồi im lặng thưởng thức tách trà ấm",
    category: "giao_tiep",
    sortOrder: 29,
  ),
  ActionCatalogItem(
    code: "ACT_30",
    triggers: {"A4", "A10"},
    content: "Bố mẹ chủ động giảm bớt việc nhà cho con nghỉ ngơi",
    category: "ho_tro",
    sortOrder: 30,
  ),
  ActionCatalogItem(
    code: "ACT_31",
    triggers: {"A4", "A10"},
    content: "Bố mẹ tắt bớt thiết bị điện tử gây xao nhãng trong nhà",
    category: "quan_sat",
    sortOrder: 31,
  ),
  ActionCatalogItem(
    code: "ACT_32",
    triggers: {"A4", "A10"},
    content: "Bố mẹ chuẩn bị bữa ăn giàu vitamin, dễ tiêu hóa",
    category: "giao_tiep",
    sortOrder: 32,
  ),
  ActionCatalogItem(
    code: "ACT_33",
    triggers: {"A4", "A10"},
    content: "Bố mẹ massage nhẹ vùng vai gáy giúp con giảm căng cơ",
    category: "ho_tro",
    sortOrder: 33,
  ),
  ActionCatalogItem(
    code: "ACT_34",
    triggers: {"A4", "A10"},
    content: "Bố mẹ đảm bảo phòng ngủ của con tối và yên tĩnh",
    category: "quan_sat",
    sortOrder: 34,
  ),
  ActionCatalogItem(
    code: "ACT_35",
    triggers: {"A4", "A10"},
    content: "Cùng nghe nhạc thư giãn hoặc tiếng ồn trắng trước khi ngủ.",
    category: "giao_tiep",
    sortOrder: 35,
  ),
  ActionCatalogItem(
    code: "ACT_36",
    triggers: {"A4", "A10"},
    content: "Cùng thực hiện bài tập hít thở sâu 4-7-8 trong 3 phút.",
    category: "ho_tro",
    sortOrder: 36,
  ),
  ActionCatalogItem(
    code: "ACT_37",
    triggers: {"A4", "A10"},
    content:
        "Chủ động giảm bớt các việc nhà hoặc bài tập không bắt buộc cho con.",
    category: "quan_sat",
    sortOrder: 37,
  ),
  ActionCatalogItem(
    code: "ACT_38",
    triggers: {"A4", "A10"},
    content: "Chuẩn bị bữa ăn nhẹ dễ tiêu hóa và giàu dinh dưỡng (súp, cháo).",
    category: "giao_tiep",
    sortOrder: 38,
  ),
  ActionCatalogItem(
    code: "ACT_39",
    triggers: {"A5"},
    content:
        "Bố mẹ dành 10–15 phút ở cạnh con và bắt đầu bằng một chủ đề con thích thay vì hỏi ngay chuyện học tập hoặc kết quả ở trường.",
    category: "ho_tro",
    sortOrder: 39,
  ),
  ActionCatalogItem(
    code: "ACT_40",
    triggers: {"A5"},
    content:
        "Bố mẹ hoặc người thân cùng con đi dạo ngắn, ăn món con thích hoặc đổi không khí ở nơi con cảm thấy dễ chịu.",
    category: "quan_sat",
    sortOrder: 40,
  ),
  ActionCatalogItem(
    code: "ACT_41",
    triggers: {"A5"},
    content:
        "Bố mẹ cùng con thử kể ra 3 điều khiến hôm nay dễ chịu hơn một chút, dù là những điều rất nhỏ.",
    category: "giao_tiep",
    sortOrder: 41,
  ),
  ActionCatalogItem(
    code: "ACT_42",
    triggers: {"A5"},
    content:
        "Nếu con chưa muốn nói chuyện, bố mẹ hoặc người thân có thể chỉ ở cạnh con, cùng xem phim, nghe nhạc hoặc làm điều con thích.",
    category: "ho_tro",
    sortOrder: 42,
  ),
  ActionCatalogItem(
    code: "ACT_43",
    triggers: {"A5"},
    content:
        "Bố mẹ nhẹ nhàng hỏi: “Dạo này có điều gì làm con thấy không vui hơn bình thường không?” và ưu tiên lắng nghe trước khi đưa lời khuyên.",
    category: "quan_sat",
    sortOrder: 43,
  ),
  ActionCatalogItem(
    code: "ACT_44",
    triggers: {"A5", "A9"},
    content: "Cùng ngồi trò chuyện không giới hạn thời gian",
    category: "giao_tiep",
    sortOrder: 44,
  ),
  ActionCatalogItem(
    code: "ACT_45",
    triggers: {"A5", "A9"},
    content: "Cùng chuẩn bị một món ăn mới trong bếp",
    category: "ho_tro",
    sortOrder: 45,
  ),
  ActionCatalogItem(
    code: "ACT_46",
    triggers: {"A5", "A9"},
    content: "Cùng xem lại ảnh kỷ niệm từ thời con còn nhỏ",
    category: "quan_sat",
    sortOrder: 46,
  ),
  ActionCatalogItem(
    code: "ACT_47",
    triggers: {"A5", "A9"},
    content: "Cùng đi ăn ngoài để thay đổi không khí",
    category: "giao_tiep",
    sortOrder: 47,
  ),
  ActionCatalogItem(
    code: "ACT_48",
    triggers: {"A5", "A9"},
    content: "Cùng tham gia một buổi vẽ tranh/tô màu nghệ thuật",
    category: "ho_tro",
    sortOrder: 48,
  ),
  ActionCatalogItem(
    code: "ACT_49",
    triggers: {"A5", "A9"},
    content: "Bố mẹ trao một cái ôm thật chặt (trên 8 giây)",
    category: "quan_sat",
    sortOrder: 49,
  ),
  ActionCatalogItem(
    code: "ACT_50",
    triggers: {"A5", "A9"},
    content: "Bố mẹ lắng nghe mà không đưa ra lời phán xét",
    category: "giao_tiep",
    sortOrder: 50,
  ),
  ActionCatalogItem(
    code: "ACT_51",
    triggers: {"A5", "A9"},
    content: "Bố mẹ để lại mẩu giấy: \"Bố mẹ luôn ở đây vì con\"",
    category: "ho_tro",
    sortOrder: 51,
  ),
  ActionCatalogItem(
    code: "ACT_52",
    triggers: {"A5", "A9"},
    content: "Bố mẹ tôn trọng không gian riêng nếu con chưa muốn nói",
    category: "quan_sat",
    sortOrder: 52,
  ),
  ActionCatalogItem(
    code: "ACT_53",
    triggers: {"A5", "A9"},
    content: "Bố mẹ nhắc lại một điểm mạnh/phẩm chất tốt của con",
    category: "giao_tiep",
    sortOrder: 53,
  ),
  ActionCatalogItem(
    code: "ACT_54",
    triggers: {"A5", "A9"},
    content: "Cùng xem một bộ phim nhẹ nhàng hoặc lật xem lại album ảnh cũ.",
    category: "ho_tro",
    sortOrder: 54,
  ),
  ActionCatalogItem(
    code: "ACT_55",
    triggers: {"A5", "A9"},
    content: "Cùng đi dạo ở nơi có nhiều cây xanh hoặc công viên.",
    category: "quan_sat",
    sortOrder: 55,
  ),
  ActionCatalogItem(
    code: "ACT_56",
    triggers: {"A5", "A9"},
    content: "Trao một cái ôm ấm áp (ít nhất 8 giây) để xoa dịu cảm xúc.",
    category: "giao_tiep",
    sortOrder: 56,
  ),
  ActionCatalogItem(
    code: "ACT_57",
    triggers: {"A5", "A9"},
    content: "Viết một lời nhắn cổ vũ dán lên bàn học hoặc gương cho con.",
    category: "ho_tro",
    sortOrder: 57,
  ),
  ActionCatalogItem(
    code: "ACT_58",
    triggers: {"A6"},
    content:
        "Bố mẹ cùng con viết nhanh những điều đang khiến con lo và thử chọn điều nào có thể xử lý trước.",
    category: "quan_sat",
    sortOrder: 58,
  ),
  ActionCatalogItem(
    code: "ACT_59",
    triggers: {"A6"},
    content:
        "Bố mẹ hoặc người thân dành thời gian hỏi con điều gì đang khiến con bận tâm gần đây mà chưa vội đưa lời khuyên hoặc đánh giá.",
    category: "giao_tiep",
    sortOrder: 59,
  ),
  ActionCatalogItem(
    code: "ACT_60",
    triggers: {"A6"},
    content:
        "Bố mẹ cùng con chia nhỏ vấn đề khiến con căng thẳng thành từng bước nhỏ để giảm cảm giác quá tải.",
    category: "ho_tro",
    sortOrder: 60,
  ),
  ActionCatalogItem(
    code: "ACT_61",
    triggers: {"A6"},
    content:
        "Bố mẹ cùng con thử một hoạt động thư giãn ngắn như đi bộ, nghe nhạc hoặc nghỉ khỏi môi trường đang gây căng thẳng.",
    category: "quan_sat",
    sortOrder: 61,
  ),
  ActionCatalogItem(
    code: "ACT_62",
    triggers: {"A6"},
    content:
        "Bố mẹ có thể nhắc con rằng không cần giải quyết mọi việc cùng lúc và gia đình có thể cùng tìm cách từng bước.",
    category: "giao_tiep",
    sortOrder: 62,
  ),
  ActionCatalogItem(
    code: "ACT_63",
    triggers: {"A6", "A7"},
    content: "Cùng liệt kê nỗi lo ra giấy và phân loại chúng",
    category: "ho_tro",
    sortOrder: 63,
  ),
  ActionCatalogItem(
    code: "ACT_64",
    triggers: {"A6", "A7"},
    content: "Cùng tô màu Mandala để tập trung tâm trí",
    category: "quan_sat",
    sortOrder: 64,
  ),
  ActionCatalogItem(
    code: "ACT_65",
    triggers: {"A6", "A7"},
    content: "Cùng thực hiện thử thách \"1 giờ không điện thoại\"",
    category: "giao_tiep",
    sortOrder: 65,
  ),
  ActionCatalogItem(
    code: "ACT_66",
    triggers: {"A6", "A7"},
    content: "Cùng sắp xếp lại bàn học cho gọn gàng",
    category: "ho_tro",
    sortOrder: 66,
  ),
  ActionCatalogItem(
    code: "ACT_67",
    triggers: {"A6", "A7"},
    content: "Cùng đi dạo bộ nhanh để đốt cháy hormone căng thẳng",
    category: "quan_sat",
    sortOrder: 67,
  ),
  ActionCatalogItem(
    code: "ACT_68",
    triggers: {"A6", "A7"},
    content: "Bố mẹ giúp con chia nhỏ bài tập lớn thành các phần 15 phút",
    category: "giao_tiep",
    sortOrder: 68,
  ),
  ActionCatalogItem(
    code: "ACT_69",
    triggers: {"A6", "A7"},
    content: "Bố mẹ kể về cách mình đã vượt qua áp lực tương tự",
    category: "ho_tro",
    sortOrder: 69,
  ),
  ActionCatalogItem(
    code: "ACT_70",
    triggers: {"A6", "A7"},
    content: "Bố mẹ chuẩn bị trà thảo mộc giúp con dịu thần kinh",
    category: "quan_sat",
    sortOrder: 70,
  ),
  ActionCatalogItem(
    code: "ACT_71",
    triggers: {"A6", "A7"},
    content: "Bố mẹ khẳng định: \"Thất bại là một phần của việc học\"",
    category: "giao_tiep",
    sortOrder: 71,
  ),
  ActionCatalogItem(
    code: "ACT_72",
    triggers: {"A6", "A7"},
    content: "Bố mẹ giảm bớt kỳ vọng về điểm số trong giai đoạn này",
    category: "ho_tro",
    sortOrder: 72,
  ),
  ActionCatalogItem(
    code: "ACT_73",
    triggers: {"A6", "A7"},
    content:
        "Cùng vẽ \"sơ đồ lo lắng\" để tách biệt những việc con có thể kiểm soát.",
    category: "quan_sat",
    sortOrder: 73,
  ),
  ActionCatalogItem(
    code: "ACT_74",
    triggers: {"A6", "A7"},
    content:
        "Cùng thực hiện một hoạt động thủ công (tô màu, xếp giấy) để tập trung tâm trí.",
    category: "giao_tiep",
    sortOrder: 74,
  ),
  ActionCatalogItem(
    code: "ACT_75",
    triggers: {"A6", "A7"},
    content:
        "Chia nhỏ các đầu việc lớn của con thành các bước nhỏ dễ thực hiện.",
    category: "ho_tro",
    sortOrder: 75,
  ),
  ActionCatalogItem(
    code: "ACT_76",
    triggers: {"A6", "A7"},
    content: "Chuẩn bị trà thảo mộc ấm (trà hoa cúc) giúp con dịu thần kinh.",
    category: "quan_sat",
    sortOrder: 76,
  ),
  ActionCatalogItem(
    code: "ACT_77",
    triggers: {"A7"},
    content:
        "Bố mẹ cùng con xem lại lịch học, lịch hoạt động hoặc các việc gần đây để giảm bớt một việc chưa thực sự cần thiết.",
    category: "giao_tiep",
    sortOrder: 77,
  ),
  ActionCatalogItem(
    code: "ACT_78",
    triggers: {"A7"},
    content:
        "Bố mẹ cùng con chia nhỏ những việc đang phải làm thành các bước nhỏ hơn để dễ bắt đầu.",
    category: "ho_tro",
    sortOrder: 78,
  ),
  ActionCatalogItem(
    code: "ACT_79",
    triggers: {"A7"},
    content:
        "Bố mẹ hoặc người thân thử hỏi điều gì đang khiến con thấy mệt hoặc áp lực nhất gần đây để cùng tìm cách giảm bớt.",
    category: "quan_sat",
    sortOrder: 79,
  ),
  ActionCatalogItem(
    code: "ACT_80",
    triggers: {"A7"},
    content:
        "Bố mẹ cùng con lên kế hoạch nghỉ ngắn giữa các khoảng học hoặc làm việc thay vì cố hoàn thành liên tục.",
    category: "giao_tiep",
    sortOrder: 80,
  ),
  ActionCatalogItem(
    code: "ACT_81",
    triggers: {"A7"},
    content:
        "Bố mẹ hỗ trợ con xác định việc nào cần ưu tiên trước để giảm cảm giác bị quá nhiều việc đè lên cùng lúc.",
    category: "ho_tro",
    sortOrder: 81,
  ),
  ActionCatalogItem(
    code: "ACT_82",
    triggers: {"A8"},
    content:
        "Bố mẹ thử hỏi: “Điều gì làm con thấy khó chịu nhất lúc này?” thay vì tập trung vào đúng – sai ngay lập tức.",
    category: "quan_sat",
    sortOrder: 82,
  ),
  ActionCatalogItem(
    code: "ACT_83",
    triggers: {"A8"},
    content:
        "Nếu con chưa muốn nói chuyện, bố mẹ có thể cho con thêm thời gian và quay lại khi con sẵn sàng hơn.",
    category: "giao_tiep",
    sortOrder: 83,
  ),
  ActionCatalogItem(
    code: "ACT_84",
    triggers: {"A8", "B9"},
    content:
        "Khi con đang khó chịu, bố mẹ có thể chờ cả hai bình tĩnh hơn rồi cùng nói chuyện lại thay vì tranh luận ngay lúc đó.",
    category: "ho_tro",
    sortOrder: 84,
  ),
  ActionCatalogItem(
    code: "ACT_85",
    triggers: {"A8", "B9"},
    content:
        "Bố mẹ hoặc người thân cùng con thử đổi không gian, đi dạo hoặc làm hoạt động thư giãn ngắn để giảm căng thẳng.",
    category: "quan_sat",
    sortOrder: 85,
  ),
  ActionCatalogItem(
    code: "ACT_86",
    triggers: {"A8", "B9"},
    content:
        "Bố mẹ cùng con thử xác định điều gì đang khiến con bực hoặc khó chịu nhiều nhất gần đây để tìm cách hạn chế tác động đó.",
    category: "giao_tiep",
    sortOrder: 86,
  ),
  ActionCatalogItem(
    code: "ACT_87",
    triggers: {"A8", "B9"},
    content: "Cùng đếm từ 1 đến 10 trước khi tranh luận",
    category: "ho_tro",
    sortOrder: 87,
  ),
  ActionCatalogItem(
    code: "ACT_88",
    triggers: {"A8", "B9"},
    content: "Cùng đi rửa mặt bằng nước lạnh để giảm kích động",
    category: "quan_sat",
    sortOrder: 88,
  ),
  ActionCatalogItem(
    code: "ACT_89",
    triggers: {"A8", "B9"},
    content: "Cùng dọn dẹp nhà cửa để xả năng lượng thừa",
    category: "giao_tiep",
    sortOrder: 89,
  ),
  ActionCatalogItem(
    code: "ACT_90",
    triggers: {"A8", "B9"},
    content: "Cùng nghe nhạc sôi động để chuyển hóa cơn giận",
    category: "ho_tro",
    sortOrder: 90,
  ),
  ActionCatalogItem(
    code: "ACT_91",
    triggers: {"A8", "B9"},
    content: "Cùng uống một ly nước lọc lớn một cách chậm rãi",
    category: "quan_sat",
    sortOrder: 91,
  ),
  ActionCatalogItem(
    code: "ACT_92",
    triggers: {"A8", "B9"},
    content: "Bố mẹ giữ bình tĩnh, không quát tháo khi con đang nóng",
    category: "giao_tiep",
    sortOrder: 92,
  ),
  ActionCatalogItem(
    code: "ACT_93",
    triggers: {"A8", "B9"},
    content: "Bố mẹ sử dụng tông giọng thấp và chậm khi nói chuyện",
    category: "ho_tro",
    sortOrder: 93,
  ),
  ActionCatalogItem(
    code: "ACT_94",
    triggers: {"A8", "B9"},
    content: "Bố mẹ cho con một khoảng nghỉ (timeout) 15 phút",
    category: "quan_sat",
    sortOrder: 94,
  ),
  ActionCatalogItem(
    code: "ACT_95",
    triggers: {"A8", "B9"},
    content: "Bố mẹ sử dụng tinh dầu bạc hà làm mát không gian",
    category: "giao_tiep",
    sortOrder: 95,
  ),
  ActionCatalogItem(
    code: "ACT_96",
    triggers: {"A8", "B9"},
    content: "Bố mẹ sẵn sàng xin lỗi nếu lỡ lời làm con khó chịu",
    category: "ho_tro",
    sortOrder: 96,
  ),
  ActionCatalogItem(
    code: "ACT_97",
    triggers: {"A8", "B9"},
    content:
        "Cùng thực hiện thử thách \"im lặng 5 phút\" để cả hai cùng bình tĩnh.",
    category: "quan_sat",
    sortOrder: 97,
  ),
  ActionCatalogItem(
    code: "ACT_98",
    triggers: {"A8", "B9"},
    content:
        "Cùng tham gia một hoạt động xả năng lượng (đấm bao cát, chạy bộ).",
    category: "giao_tiep",
    sortOrder: 98,
  ),
  ActionCatalogItem(
    code: "ACT_99",
    triggers: {"A8", "B9"},
    content:
        "Rửa mặt bằng nước lạnh cho con hoặc hướng dẫn con làm vậy để \"hạ hỏa\".",
    category: "ho_tro",
    sortOrder: 99,
  ),
  ActionCatalogItem(
    code: "ACT_100",
    triggers: {"A8", "B9"},
    content:
        "Giữ khoảng cách cần thiết, tránh tranh luận gay gắt khi con đang nóng nảy.",
    category: "quan_sat",
    sortOrder: 100,
  ),
  ActionCatalogItem(
    code: "ACT_101",
    triggers: {"A9"},
    content:
        "Bố mẹ hoặc người thân dành thời gian ở cạnh con nhiều hơn trong ngày, kể cả chỉ là cùng ăn, xem phim hoặc ngồi cạnh mà không cần nói nhiều.",
    category: "giao_tiep",
    sortOrder: 101,
  ),
  ActionCatalogItem(
    code: "ACT_102",
    triggers: {"A9"},
    content:
        "Bố mẹ cùng con chủ động kết nối lại với một người bạn hoặc người thân mà con cảm thấy thoải mái khi trò chuyện.",
    category: "ho_tro",
    sortOrder: 102,
  ),
  ActionCatalogItem(
    code: "ACT_103",
    triggers: {"A9"},
    content:
        "Bố mẹ hoặc người thân rủ con tham gia một hoạt động nhỏ cùng gia đình như nấu ăn, đi dạo hoặc chơi trò nhẹ nhàng.",
    category: "quan_sat",
    sortOrder: 103,
  ),
  ActionCatalogItem(
    code: "ACT_104",
    triggers: {"A9"},
    content:
        "Nếu con chưa muốn chia sẻ nhiều, bố mẹ có thể nói với con rằng khi nào sẵn sàng thì luôn có người ở đây để lắng nghe.",
    category: "giao_tiep",
    sortOrder: 104,
  ),
  ActionCatalogItem(
    code: "ACT_105",
    triggers: {"A9"},
    content:
        "Bố mẹ cùng con thử lên kế hoạch cho một hoạt động con mong chờ trong vài ngày tới để tạo cảm giác kết nối và có điều để chờ đợi.",
    category: "ho_tro",
    sortOrder: 105,
  ),
  ActionCatalogItem(
    code: "ACT_106",
    triggers: {"A9"},
    content: "Cùng viết \"Hợp đồng cảm xúc\" (cam kết lắng nghe)",
    category: "quan_sat",
    sortOrder: 106,
  ),
  ActionCatalogItem(
    code: "ACT_107",
    triggers: {"A9"},
    content: "Cùng xây dựng \"Hộp hạnh phúc\" chứa kỷ niệm đẹp",
    category: "giao_tiep",
    sortOrder: 107,
  ),
  ActionCatalogItem(
    code: "ACT_108",
    triggers: {"A9"},
    content: "Bố mẹ dành toàn bộ thời gian cuối tuần chỉ cho con",
    category: "ho_tro",
    sortOrder: 108,
  ),
  ActionCatalogItem(
    code: "ACT_109",
    triggers: {"A10"},
    content:
        "Bố mẹ cùng con tạm dừng bớt một số việc chưa thực sự cần thiết trong hôm nay để con có thêm thời gian nghỉ ngơi.",
    category: "quan_sat",
    sortOrder: 109,
  ),
  ActionCatalogItem(
    code: "ACT_110",
    triggers: {"A10"},
    content:
        "Bố mẹ cùng con xem lại lịch học, sinh hoạt hoặc áp lực gần đây để điều chỉnh nhịp độ phù hợp hơn.",
    category: "giao_tiep",
    sortOrder: 110,
  ),
  ActionCatalogItem(
    code: "ACT_111",
    triggers: {"A10"},
    content:
        "Người thân có thể hỗ trợ con một số việc nhỏ trong ngày để con có thêm thời gian phục hồi năng lượng.",
    category: "ho_tro",
    sortOrder: 111,
  ),
  ActionCatalogItem(
    code: "ACT_112",
    triggers: {"A10"},
    content:
        "Bố mẹ cùng con dành thời gian nghỉ ở không gian yên tĩnh hơn, hạn chế thêm các kích thích gây mệt mỏi.",
    category: "quan_sat",
    sortOrder: 112,
  ),
  ActionCatalogItem(
    code: "ACT_113",
    triggers: {"A10"},
    content:
        "Bố mẹ cùng con ưu tiên nghỉ ngơi, ăn uống đầy đủ và ngủ sớm hơn trong vài ngày tới nếu có thể.",
    category: "giao_tiep",
    sortOrder: 113,
  ),
  ActionCatalogItem(
    code: "ACT_114",
    triggers: {"A10"},
    content: "Bố mẹ khẳng định: \"Mẹ tự hào về con dù có chuyện gì\"",
    category: "ho_tro",
    sortOrder: 114,
  ),
  ActionCatalogItem(
    code: "ACT_115",
    triggers: {"B1"},
    content:
        "Bố mẹ chuẩn bị sẵn đồ dùng cần thiết hoặc hỏi con xem điều gì có thể giúp con thấy dễ chịu hơn trong kỳ kinh.",
    category: "quan_sat",
    sortOrder: 115,
  ),
  ActionCatalogItem(
    code: "ACT_116",
    triggers: {"B1"},
    content:
        "Bố mẹ tạo điều kiện để con nghỉ ngơi thêm, ngủ đủ hoặc giảm bớt lịch quá dày nếu con đang mệt.",
    category: "giao_tiep",
    sortOrder: 116,
  ),
  ActionCatalogItem(
    code: "ACT_117",
    triggers: {"B1"},
    content:
        "Bố mẹ cùng con chuẩn bị đồ ăn ấm, dễ chịu hoặc nước ấm nếu con thấy khó chịu cơ thể.",
    category: "ho_tro",
    sortOrder: 117,
  ),
  ActionCatalogItem(
    code: "ACT_118",
    triggers: {"B1"},
    content:
        "Nếu con đau bụng hoặc đau lưng, bố mẹ có thể hỗ trợ chườm ấm hoặc nghỉ ngơi thêm.",
    category: "quan_sat",
    sortOrder: 118,
  ),
  ActionCatalogItem(
    code: "ACT_119",
    triggers: {"B1"},
    content:
        "Bố mẹ nhẹ nhàng hỏi thăm cảm giác của con trong kỳ kinh để hiểu điều gì giúp con dễ chịu hơn ở mỗi lần tiếp theo.",
    category: "giao_tiep",
    sortOrder: 119,
  ),
  ActionCatalogItem(
    code: "ACT_120",
    triggers: {"B1", "B4", "B5"},
    content:
        "Cùng thực hiện các động tác giãn cơ nhẹ nhàng (Yoga tư thế đứa trẻ).",
    category: "ho_tro",
    sortOrder: 120,
  ),
  ActionCatalogItem(
    code: "ACT_121",
    triggers: {"B1", "B4", "B5"},
    content:
        "Cùng chọn trang phục thoải mái, rộng rãi cho các hoạt động trong ngày.",
    category: "quan_sat",
    sortOrder: 121,
  ),
  ActionCatalogItem(
    code: "ACT_122",
    triggers: {"B1", "B4", "B5"},
    content: "Chuẩn bị túi chườm ấm vùng bụng hoặc lưng cho con.",
    category: "giao_tiep",
    sortOrder: 122,
  ),
  ActionCatalogItem(
    code: "ACT_123",
    triggers: {"B1", "B4", "B5"},
    content: "Nhắc con tránh đồ uống lạnh và bổ sung thực phẩm giàu sắt.",
    category: "ho_tro",
    sortOrder: 123,
  ),
  ActionCatalogItem(
    code: "ACT_124",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Cùng tìm hiểu về các giai đoạn của chu kỳ (B1)",
    category: "quan_sat",
    sortOrder: 124,
  ),
  ActionCatalogItem(
    code: "ACT_125",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Cùng tập tư thế Yoga \"đứa trẻ\" giảm đau lưng",
    category: "giao_tiep",
    sortOrder: 125,
  ),
  ActionCatalogItem(
    code: "ACT_126",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Cùng đi mua sắm sản phẩm vệ sinh phù hợp",
    category: "ho_tro",
    sortOrder: 126,
  ),
  ActionCatalogItem(
    code: "ACT_127",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Cùng theo dõi chu kỳ qua app điện thoại",
    category: "quan_sat",
    sortOrder: 127,
  ),
  ActionCatalogItem(
    code: "ACT_128",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Cùng thảo luận về cách vệ sinh cơ thể đúng cách",
    category: "giao_tiep",
    sortOrder: 128,
  ),
  ActionCatalogItem(
    code: "ACT_129",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Bố mẹ chuẩn bị túi chườm ấm vùng bụng cho con",
    category: "ho_tro",
    sortOrder: 129,
  ),
  ActionCatalogItem(
    code: "ACT_130",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Bố mẹ nấu nước gừng ấm hoặc trà thảo mộc",
    category: "quan_sat",
    sortOrder: 130,
  ),
  ActionCatalogItem(
    code: "ACT_131",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Bố mẹ chuẩn bị thực phẩm giàu sắt (thịt bò, rau xanh)",
    category: "giao_tiep",
    sortOrder: 131,
  ),
  ActionCatalogItem(
    code: "ACT_132",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Bố mẹ nhắc con tránh đồ lạnh và vận động quá mạnh",
    category: "ho_tro",
    sortOrder: 132,
  ),
  ActionCatalogItem(
    code: "ACT_133",
    triggers: {"B1", "B4", "B5", "B6"},
    content: "Bố mẹ tặng con chiếc gối ôm mềm mại để dễ ngủ",
    category: "quan_sat",
    sortOrder: 133,
  ),
  ActionCatalogItem(
    code: "ACT_134",
    triggers: {"B3"},
    content:
        "Bố mẹ cùng con nghỉ ngơi ở nơi yên tĩnh hơn, hạn chế màn hình hoặc ánh sáng mạnh trong một khoảng thời gian ngắn.",
    category: "giao_tiep",
    sortOrder: 134,
  ),
  ActionCatalogItem(
    code: "ACT_135",
    triggers: {"B3"},
    content:
        "Bố mẹ nhắc con uống đủ nước, nghỉ ngắn và quan sát xem cơn đau đầu xuất hiện vào thời điểm nào trong ngày.",
    category: "ho_tro",
    sortOrder: 135,
  ),
  ActionCatalogItem(
    code: "ACT_136",
    triggers: {"B3"},
    content:
        "Bố mẹ cùng con xem lại thời gian ngủ gần đây vì thiếu ngủ đôi khi có thể khiến cơ thể dễ mệt hoặc đau đầu hơn.",
    category: "quan_sat",
    sortOrder: 136,
  ),
  ActionCatalogItem(
    code: "ACT_137",
    triggers: {"B3"},
    content:
        "Người thân có thể hỗ trợ giảm bớt hoạt động gây căng thẳng để con có thêm thời gian nghỉ ngơi.",
    category: "giao_tiep",
    sortOrder: 137,
  ),
  ActionCatalogItem(
    code: "ACT_138",
    triggers: {"B3"},
    content:
        "Nếu tình trạng xuất hiện nhiều lần, bố mẹ có thể tiếp tục theo dõi tần suất để hiểu rõ hơn điều gì đang ảnh hưởng đến con.",
    category: "ho_tro",
    sortOrder: 138,
  ),
  ActionCatalogItem(
    code: "ACT_139",
    triggers: {"B3", "B7"},
    content: "Cùng ngồi nghỉ ngơi ở không gian yên tĩnh, ít ánh sáng mạnh.",
    category: "quan_sat",
    sortOrder: 139,
  ),
  ActionCatalogItem(
    code: "ACT_140",
    triggers: {"B3", "B7"},
    content: "Cùng theo dõi lượng nước uống trong ngày để đảm bảo con đủ nước.",
    category: "giao_tiep",
    sortOrder: 140,
  ),
  ActionCatalogItem(
    code: "ACT_141",
    triggers: {"B3", "B7"},
    content: "Massage nhẹ nhàng vùng thái dương và cổ vai gáy cho con.",
    category: "ho_tro",
    sortOrder: 141,
  ),
  ActionCatalogItem(
    code: "ACT_142",
    triggers: {"B3", "B7"},
    content: "Tắt các thiết bị điện tử và nhắc con đi ngủ sớm hơn thường lệ.",
    category: "quan_sat",
    sortOrder: 142,
  ),
  ActionCatalogItem(
    code: "ACT_143",
    triggers: {"B3", "B7", "B8"},
    content: "Cùng làm mặt nạ tự nhiên (dưa leo) giảm mụn",
    category: "giao_tiep",
    sortOrder: 143,
  ),
  ActionCatalogItem(
    code: "ACT_144",
    triggers: {"B3", "B7", "B8"},
    content: "Cùng đắp khăn mát lên trán khi con đau đầu",
    category: "ho_tro",
    sortOrder: 144,
  ),
  ActionCatalogItem(
    code: "ACT_145",
    triggers: {"B3", "B7", "B8"},
    content: "Cùng thiết lập thói quen uống đủ 2 lít nước/ngày",
    category: "quan_sat",
    sortOrder: 145,
  ),
  ActionCatalogItem(
    code: "ACT_146",
    triggers: {"B3", "B7", "B8"},
    content: "Cùng đi khám bác sĩ nếu triệu chứng kéo dài",
    category: "giao_tiep",
    sortOrder: 146,
  ),
  ActionCatalogItem(
    code: "ACT_147",
    triggers: {"B3", "B7", "B8"},
    content: "Cùng thực hành massage nhẹ vùng thái dương",
    category: "ho_tro",
    sortOrder: 147,
  ),
  ActionCatalogItem(
    code: "ACT_148",
    triggers: {"B3", "B7", "B8"},
    content: "Bố mẹ mua sản phẩm chăm sóc da dịu nhẹ cho con",
    category: "quan_sat",
    sortOrder: 148,
  ),
  ActionCatalogItem(
    code: "ACT_149",
    triggers: {"B3", "B7", "B8"},
    content: "Bố mẹ giảm độ sáng đèn trong nhà khi con chóng mặt",
    category: "giao_tiep",
    sortOrder: 149,
  ),
  ActionCatalogItem(
    code: "ACT_150",
    triggers: {"B3", "B7", "B8"},
    content: "Bố mẹ nhắc con không tự ý nặn mụn tránh để lại sẹo",
    category: "ho_tro",
    sortOrder: 150,
  ),
  ActionCatalogItem(
    code: "ACT_151",
    triggers: {"B3", "B7", "B8"},
    content: "Bố mẹ thay vỏ gối thường xuyên cho con",
    category: "quan_sat",
    sortOrder: 151,
  ),
  ActionCatalogItem(
    code: "ACT_152",
    triggers: {"B3", "B7", "B8"},
    content: "Bố mẹ chuẩn bị thực phẩm thanh nhiệt (đỗ đen, rau má)",
    category: "giao_tiep",
    sortOrder: 152,
  ),
  ActionCatalogItem(
    code: "ACT_153",
    triggers: {"B4"},
    content:
        "Bố mẹ cùng con nghỉ ngơi nhẹ, ăn đồ dễ tiêu và theo dõi xem cơn đau xuất hiện vào thời điểm nào.",
    category: "ho_tro",
    sortOrder: 153,
  ),
  ActionCatalogItem(
    code: "ACT_154",
    triggers: {"B4"},
    content:
        "Bố mẹ hoặc người thân chuẩn bị đồ ăn ấm, nhẹ bụng và nhắc con uống đủ nước.",
    category: "quan_sat",
    sortOrder: 154,
  ),
  ActionCatalogItem(
    code: "ACT_155",
    triggers: {"B4"},
    content:
        "Nếu con đang trong kỳ kinh nguyệt, bố mẹ có thể chuẩn bị túi chườm ấm hoặc tạo điều kiện để con nghỉ ngơi thêm.",
    category: "giao_tiep",
    sortOrder: 155,
  ),
  ActionCatalogItem(
    code: "ACT_156",
    triggers: {"B4"},
    content:
        "Bố mẹ cùng con quan sát xem đau bụng có liên quan đến ăn uống, căng thẳng hoặc thời điểm đặc biệt nào không.",
    category: "ho_tro",
    sortOrder: 156,
  ),
  ActionCatalogItem(
    code: "ACT_157",
    triggers: {"B4"},
    content:
        "Nếu đau bụng lặp lại nhiều ngày, bố mẹ có thể tiếp tục theo dõi thêm để hiểu rõ hơn tình trạng của con.",
    category: "quan_sat",
    sortOrder: 157,
  ),
  ActionCatalogItem(
    code: "ACT_158",
    triggers: {"B5"},
    content:
        "Bố mẹ cùng con nghỉ ngơi, thay đổi tư thế ngồi hoặc vận động nhẹ nhàng nếu con thấy phù hợp.",
    category: "giao_tiep",
    sortOrder: 158,
  ),
  ActionCatalogItem(
    code: "ACT_159",
    triggers: {"B5"},
    content:
        "Bố mẹ cùng con xem lại thời gian ngồi học, mang cặp hoặc tư thế gần đây để giảm bớt áp lực lên cơ thể.",
    category: "ho_tro",
    sortOrder: 159,
  ),
  ActionCatalogItem(
    code: "ACT_160",
    triggers: {"B5"},
    content:
        "Nếu con đang trong kỳ kinh nguyệt, bố mẹ có thể hỗ trợ chườm ấm hoặc tạo thêm thời gian nghỉ ngơi.",
    category: "quan_sat",
    sortOrder: 160,
  ),
  ActionCatalogItem(
    code: "ACT_161",
    triggers: {"B5"},
    content:
        "Người thân có thể hỗ trợ giảm bớt việc nặng hoặc hoạt động khiến con khó chịu hơn trong hôm nay.",
    category: "giao_tiep",
    sortOrder: 161,
  ),
  ActionCatalogItem(
    code: "ACT_162",
    triggers: {"B5"},
    content:
        "Nếu tình trạng xuất hiện thường xuyên, bố mẹ có thể tiếp tục theo dõi thêm để hiểu rõ hơn điều gì đang ảnh hưởng đến con.",
    category: "ho_tro",
    sortOrder: 162,
  ),
  ActionCatalogItem(
    code: "ACT_163",
    triggers: {"B6"},
    content:
        "Bố mẹ cùng con nghỉ ngơi ngắn, tránh đồ ăn quá nặng mùi và ưu tiên món nhẹ, dễ ăn hơn.",
    category: "quan_sat",
    sortOrder: 163,
  ),
  ActionCatalogItem(
    code: "ACT_164",
    triggers: {"B6"},
    content:
        "Bố mẹ nhắc con uống nước từng ngụm nhỏ và dành thêm thời gian nghỉ nếu cần.",
    category: "giao_tiep",
    sortOrder: 164,
  ),
  ActionCatalogItem(
    code: "ACT_165",
    triggers: {"B6"},
    content:
        "Bố mẹ cùng con quan sát xem cảm giác khó chịu xuất hiện vào thời điểm nào để hiểu rõ hơn điều ảnh hưởng.",
    category: "ho_tro",
    sortOrder: 165,
  ),
  ActionCatalogItem(
    code: "ACT_166",
    triggers: {"B6"},
    content:
        "Nếu con đang trong kỳ kinh nguyệt, bố mẹ có thể ưu tiên nghỉ ngơi thêm và giảm bớt hoạt động nặng.",
    category: "quan_sat",
    sortOrder: 166,
  ),
  ActionCatalogItem(
    code: "ACT_167",
    triggers: {"B6"},
    content:
        "Người thân có thể ở cạnh con thêm một lúc để hỗ trợ nếu con cảm thấy khó chịu nhiều hơn.",
    category: "giao_tiep",
    sortOrder: 167,
  ),
  ActionCatalogItem(
    code: "ACT_168",
    triggers: {"B7"},
    content:
        "Bố mẹ cùng con ngồi nghỉ ở nơi thoáng hơn và tránh thay đổi tư thế quá nhanh.",
    category: "ho_tro",
    sortOrder: 168,
  ),
  ActionCatalogItem(
    code: "ACT_169",
    triggers: {"B7"},
    content:
        "Bố mẹ nhắc con uống đủ nước, ăn nhẹ nếu con chưa ăn hoặc đang mệt.",
    category: "quan_sat",
    sortOrder: 169,
  ),
  ActionCatalogItem(
    code: "ACT_170",
    triggers: {"B7"},
    content:
        "Bố mẹ cùng con nghỉ ngơi ngắn trước khi quay lại học tập hoặc hoạt động.",
    category: "giao_tiep",
    sortOrder: 170,
  ),
  ActionCatalogItem(
    code: "ACT_171",
    triggers: {"B7"},
    content:
        "Người thân có thể hỗ trợ giảm bớt hoạt động nếu con đang cảm thấy chưa ổn.",
    category: "ho_tro",
    sortOrder: 171,
  ),
  ActionCatalogItem(
    code: "ACT_172",
    triggers: {"B7"},
    content:
        "Nếu tình trạng lặp lại nhiều lần, bố mẹ có thể tiếp tục theo dõi thêm để hiểu rõ hơn nguyên nhân ảnh hưởng.",
    category: "quan_sat",
    sortOrder: 172,
  ),
  ActionCatalogItem(
    code: "ACT_173",
    triggers: {"B9"},
    content:
        "Bố mẹ cùng con nghỉ ngơi thêm một khoảng ngắn và thử đổi sang hoạt động nhẹ nhàng hơn.",
    category: "giao_tiep",
    sortOrder: 173,
  ),
  ActionCatalogItem(
    code: "ACT_174",
    triggers: {"B9"},
    content:
        "Bố mẹ cùng con xem lại giấc ngủ, ăn uống hoặc lịch hoạt động gần đây để tìm điều có thể đang ảnh hưởng đến cơ thể con.",
    category: "ho_tro",
    sortOrder: 174,
  ),
  ActionCatalogItem(
    code: "ACT_175",
    triggers: {"B9"},
    content:
        "Người thân có thể ở cạnh và hỗ trợ con thêm trong những việc nhỏ nếu con cảm thấy mệt hơn bình thường.",
    category: "quan_sat",
    sortOrder: 175,
  ),
  ActionCatalogItem(
    code: "ACT_176",
    triggers: {"B9"},
    content:
        "Bố mẹ cùng con dành thêm thời gian nghỉ ngơi hoặc thư giãn để cơ thể phục hồi tốt hơn.",
    category: "giao_tiep",
    sortOrder: 176,
  ),
  ActionCatalogItem(
    code: "ACT_177",
    triggers: {"B9"},
    content:
        "Nếu trạng thái kéo dài, bố mẹ có thể tiếp tục theo dõi để hiểu rõ hơn điều gì đang ảnh hưởng đến con.",
    category: "ho_tro",
    sortOrder: 177,
  ),
  ActionCatalogItem(
    code: "ACT_178",
    triggers: {"C1"},
    content: "Cùng lập góc học tập mới tạo cảm hứng",
    category: "quan_sat",
    sortOrder: 178,
  ),
  ActionCatalogItem(
    code: "ACT_179",
    triggers: {"C1"},
    content: "Cùng học một kỹ năng thực tế (nấu ăn, sửa đồ)",
    category: "giao_tiep",
    sortOrder: 179,
  ),
  ActionCatalogItem(
    code: "ACT_180",
    triggers: {"C1"},
    content: "Bố mẹ tạo môi trường yên tĩnh khi con học bài",
    category: "ho_tro",
    sortOrder: 180,
  ),
  ActionCatalogItem(
    code: "ACT_181",
    triggers: {"C1", "C5"},
    content: "Cùng lập thời gian biểu học tập có xen kẽ các khoảng nghỉ ngắn.",
    category: "quan_sat",
    sortOrder: 181,
  ),
  ActionCatalogItem(
    code: "ACT_182",
    triggers: {"C1", "C5"},
    content:
        "Liên hệ khéo léo với giáo viên để nắm bắt tình hình áp lực tại trường.",
    category: "giao_tiep",
    sortOrder: 182,
  ),
  ActionCatalogItem(
    code: "ACT_183",
    triggers: {"C2"},
    content: "Cùng tổ chức buổi tiệc nhỏ mời bạn con",
    category: "ho_tro",
    sortOrder: 183,
  ),
  ActionCatalogItem(
    code: "ACT_184",
    triggers: {"C2"},
    content: "Bố mẹ tạo điều kiện cho con đi chơi với bạn",
    category: "quan_sat",
    sortOrder: 184,
  ),
  ActionCatalogItem(
    code: "ACT_185",
    triggers: {"C2", "C3"},
    content:
        "Cùng chuẩn bị một món quà nhỏ hoặc thiệp cho người bạn/thành viên gia đình.",
    category: "giao_tiep",
    sortOrder: 185,
  ),
  ActionCatalogItem(
    code: "ACT_186",
    triggers: {"C3"},
    content: "Cùng chơi Board game gia đình vào cuối tuần",
    category: "ho_tro",
    sortOrder: 186,
  ),
  ActionCatalogItem(
    code: "ACT_187",
    triggers: {"C3"},
    content: "Bố mẹ cho con bày tỏ quan điểm trong việc gia đình",
    category: "quan_sat",
    sortOrder: 187,
  ),
  ActionCatalogItem(
    code: "ACT_188",
    triggers: {"C4"},
    content: "Cùng lọc nội dung tích cực trên MXH để xem",
    category: "giao_tiep",
    sortOrder: 188,
  ),
  ActionCatalogItem(
    code: "ACT_189",
    triggers: {"C4"},
    content: "Bố mẹ đặt giới hạn thời gian thiết bị cho cả nhà",
    category: "ho_tro",
    sortOrder: 189,
  ),
  ActionCatalogItem(
    code: "ACT_190",
    triggers: {"C4", "C6"},
    content:
        "Cùng tham gia một hoạt động giải trí không thiết bị (board game, đánh bài).",
    category: "quan_sat",
    sortOrder: 190,
  ),
  ActionCatalogItem(
    code: "ACT_191",
    triggers: {"C4", "C6"},
    content:
        "Lắng nghe câu chuyện của con về bạn bè mà không đưa ra phán xét ngay.",
    category: "giao_tiep",
    sortOrder: 191,
  ),
  ActionCatalogItem(
    code: "ACT_192",
    triggers: {"C4", "C6"},
    content: "Thiết lập \"khung giờ không công nghệ\" cho cả gia đình.",
    category: "ho_tro",
    sortOrder: 192,
  ),
  ActionCatalogItem(
    code: "ACT_193",
    triggers: {"C5"},
    content: "Bố mẹ liên hệ giáo viên nắm bắt áp lực lớp học",
    category: "quan_sat",
    sortOrder: 193,
  ),
  ActionCatalogItem(
    code: "ACT_194",
    triggers: {"A11", "B10"},
    content:
        "Bố mẹ thử hỏi thêm con điều gì đang khiến con thấy khác với bình thường gần đây.",
    category: "giao_tiep",
    sortOrder: 194,
  ),
  ActionCatalogItem(
    code: "ACT_195",
    triggers: {"A11", "B10"},
    content:
        "Bố mẹ cùng con theo dõi thêm vài ngày để hiểu rõ hơn trạng thái đang diễn ra.",
    category: "ho_tro",
    sortOrder: 195,
  ),
  ActionCatalogItem(
    code: "ACT_196",
    triggers: {"A11", "B10"},
    content:
        "Người thân có thể dành thêm thời gian quan sát hoặc ở cạnh con nhiều hơn trong vài ngày tới.",
    category: "quan_sat",
    sortOrder: 196,
  ),
  ActionCatalogItem(
    code: "ACT_197",
    triggers: {"A11", "B10"},
    content:
        "Bố mẹ cùng con thử ghi nhận thời điểm trạng thái này xuất hiện để dễ hiểu hơn điều ảnh hưởng.",
    category: "giao_tiep",
    sortOrder: 197,
  ),
  ActionCatalogItem(
    code: "ACT_198",
    triggers: {"A11", "B10"},
    content:
        "Gia đình có thể tham khảo thêm nội dung phù hợp trong Thư viện để hiểu hơn về những thay đổi ở tuổi dậy thì.",
    category: "ho_tro",
    sortOrder: 198,
  ),
  ActionCatalogItem(
    code: "ACT_199",
    triggers: {"A11", "B10"},
    content: "Cùng thử một hoạt động ngẫu nhiên (gieo xúc xắc)",
    category: "quan_sat",
    sortOrder: 199,
  ),
  ActionCatalogItem(
    code: "ACT_200",
    triggers: {"A11", "B10"},
    content: "Cùng đi dạo bộ và quan sát thiên nhiên xung quanh",
    category: "giao_tiep",
    sortOrder: 200,
  ),
  ActionCatalogItem(
    code: "ACT_201",
    triggers: {"A11", "B10"},
    content: "Cùng tập một điệu nhảy ngẫu hứng theo nhạc",
    category: "ho_tro",
    sortOrder: 201,
  ),
  ActionCatalogItem(
    code: "ACT_202",
    triggers: {"A11", "B10"},
    content: "Cùng làm dự án tái chế đồ cũ trong nhà",
    category: "quan_sat",
    sortOrder: 202,
  ),
  ActionCatalogItem(
    code: "ACT_203",
    triggers: {"A11", "B10"},
    content: "Cùng cười thật to (liệu pháp cười) mỗi sáng",
    category: "giao_tiep",
    sortOrder: 203,
  ),
  ActionCatalogItem(
    code: "ACT_204",
    triggers: {"A11", "B10"},
    content: "Bố mẹ tự chăm sóc sức khỏe tinh thần của chính mình",
    category: "ho_tro",
    sortOrder: 204,
  ),
  ActionCatalogItem(
    code: "ACT_205",
    triggers: {"A11", "B10"},
    content: "Bố mẹ ghi chép biểu hiện \"Khác\" để tìm quy luật",
    category: "quan_sat",
    sortOrder: 205,
  ),
  ActionCatalogItem(
    code: "ACT_206",
    triggers: {"A11", "B10"},
    content: "Bố mẹ đọc thêm tài liệu tâm lý trong Thư viện app",
    category: "giao_tiep",
    sortOrder: 206,
  ),
  ActionCatalogItem(
    code: "ACT_207",
    triggers: {"A11", "B10"},
    content: "Bố mẹ tìm kiếm sự đồng cảm từ phụ huynh khác",
    category: "ho_tro",
    sortOrder: 207,
  ),
  ActionCatalogItem(
    code: "ACT_208",
    triggers: {"A11", "B10"},
    content: "Bố mẹ giữ thái độ tò mò, yêu thương thế giới của con.",
    category: "quan_sat",
    sortOrder: 208,
  ),
];
