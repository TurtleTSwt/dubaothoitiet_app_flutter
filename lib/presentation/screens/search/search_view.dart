import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/injection/service_locator.dart';
import '../../../logic/location/location_cubit.dart';
import '../../../logic/location/location_state.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../../data/models/location_model.dart';
import '../../../utils/constants/app_strings.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationCubit>(),
      child: const _SearchContent(),
    );
  }
}

class _SearchContent extends StatefulWidget {
  const _SearchContent();

  @override
  State<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<_SearchContent> {
  final _searchController = TextEditingController();
  bool _hasQuery = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final hasQuery = _searchController.text.trim().isNotEmpty;
      if (hasQuery != _hasQuery) {
        setState(() => _hasQuery = hasQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Gọi hàm searchCity của Dev A
      context.read<LocationCubit>().searchCity(query);
    }
  }

  void _selectCity(LocationModel city) {
    Navigator.of(context).pop(city);
  }

  @override
  Widget build(BuildContext context) {
    // Lấy ngôn ngữ hiện tại từ SettingsCubit (đã provide sẵn ở app.dart)
    final strings = AppStrings.of(context.watch<SettingsCubit>().state.language);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.searchHint.replaceAll('...', '')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _onSearch(),
              decoration: InputDecoration(
                hintText: strings.searchHint,
                // Biến icon kính lúp thành nút bấm được (phòng khi phím Enter trên Web không ăn)
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: _onSearch,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),

          // 2. KẾT QUẢ TÌM KIẾM (hoặc danh sách thành phố đã lưu nếu chưa gõ gì)
          Expanded(
            child: !_hasQuery
                ? _buildSavedCitiesList(context, strings)
                : BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                // Đang tải tìm kiếm
                if (state is LocationSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Lỗi tìm kiếm
                if (state is LocationSearchError) {
                  return Center(
                    child: Text(
                      '${strings.errorPrefix}${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // Đã tải xong danh sách tìm kiếm
                if (state is LocationSearchLoaded) {
                  final list = state.results;

                  if (list.isEmpty) {
                    return Center(
                      child: Text(strings.searchNoResults),
                    );
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_city,
                          color: Colors.blue,
                          size: 30,
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(item.country ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Chọn thành phố và trả dữ liệu về cho HomeView
                          Navigator.of(context).pop(item);
                        },
                      );
                    },
                  );
                }

                // Chưa tìm kiếm (trạng thái ban đầu) — không xảy ra vì !_hasQuery
                // đã được xử lý riêng ở trên, giữ lại cho an toàn
                return Center(
                  child: Text(strings.searchTypeToStart),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách thành phố đã lưu — hiện khi ô tìm kiếm còn trống
  Widget _buildSavedCitiesList(BuildContext context, AppStrings strings) {
    final savedCities = context.watch<SettingsCubit>().state.savedCities;

    if (savedCities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            strings.noSavedCities,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: savedCities.length,
      itemBuilder: (context, index) {
        final city = savedCities[index];
        return ListTile(
          leading: const Icon(Icons.star, color: Colors.amber, size: 28),
          title: Text(
            city.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(city.country ?? ''),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => context.read<SettingsCubit>().toggleSavedCity(city),
          ),
          onTap: () => _selectCity(city),
        );
      },
    );
  }
}