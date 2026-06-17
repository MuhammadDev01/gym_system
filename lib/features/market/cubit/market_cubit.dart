import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/market/cubit/market_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/views/widgets/market_item_filter.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitial()) {
    _loadItems();
  }

  final List<MarketModel> _allItems = [
    MarketModel(
      id: '1',
      name: 'كرياتين مونوهيدرات',
      description: 'مكمل غذائي لزيادة القوة والطاقة وتحسين الأداء العضلي',
      image: AppAssets.manHandADumbel,
      price: 250,
      type: ItemType.supplement,
    ),
    MarketModel(
      id: '2',
      name: 'بروتين واي',
      description: 'بروتين عالي الجودة لبناء العضلات والتعافي بعد التمرين',
      image: AppAssets.manHandADumbel,
      price: 420,
      type: ItemType.supplement,
    ),
    MarketModel(
      id: '3',
      name: 'جلوتامين',
      description: 'يساعد في التعافي العضلي وتقليل الإرهاق بعد التمرين',
      image: AppAssets.manHandADumbel,
      price: 180,
      type: ItemType.supplement,
    ),
    MarketModel(
      id: '4',
      name: 'ماس جينر',
      description: 'مكمل لزيادة الوزن والكتلة العضلية بسرعة',
      image: AppAssets.manHandADumbel,
      price: 380,
      type: ItemType.supplement,
    ),
    MarketModel(
      id: '5',
      name: 'حبل مقاومة',
      description: 'حبل مطاطي متعدد المستويات لتقوية العضلات',
      image: AppAssets.manHandADumbel,
      price: 120,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '6',
      name: 'دمبل قابل للتعديل',
      description: 'دمبل بوزن قابل للتعديل مناسب للتمارين المنزلية',
      image: AppAssets.manHandADumbel,
      price: 650,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '7',
      name: 'بار أتوميك',
      description: 'بار حديد لتمارين الضغط والعضلة الثنائية والثلاثية',
      image: AppAssets.manHandADumbel,
      price: 200,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '8',
      name: 'زانة بار',
      description: 'زانة بار أولمبية لتمارين رفع الأثقال',
      image: AppAssets.manHandADumbel,
      price: 850,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '9',
      name: 'تايمر توقيت',
      description: 'ساعة توقيت للمطالعة والراحة بين الجولات',
      image: AppAssets.manHandADumbel,
      price: 90,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '10',
      name: 'قفازات جيم',
      description: 'قفازات رياضية للحماية من التقرحات وتحسين القبضة',
      image: AppAssets.manHandADumbel,
      price: 150,
      type: ItemType.tool,
    ),
    MarketModel(
      id: '11',
      name: 'علبة بروتين بار',
      description: 'بار بروتين صحي عالي البروتين ومنخفض السكر',
      image: AppAssets.manHandADumbel,
      price: 75,
      type: ItemType.supplement,
    ),
  ];

  FilterType selectedFilter = FilterType.all;
  List<MarketModel> filteredItems = [];

  void _loadItems() {
    filteredItems = List.from(_allItems);
    emit(MarketLoaded());
  }

  void filterByType(FilterType filter) {
    selectedFilter = filter;
    if (filter == FilterType.all) {
      filteredItems = List.from(_allItems);
    } else {
      filteredItems = _allItems.where((item) {
        return filter == FilterType.tools
            ? item.type == ItemType.tool
            : item.type == ItemType.supplement;
      }).toList();
    }
    emit(MarketLoaded());
  }
}
