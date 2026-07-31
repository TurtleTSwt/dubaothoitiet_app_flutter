import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/injection/service_locator.dart';
import '../../../logic/location/location_cubit.dart';
import '../../../logic/location/location_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm thành phố'),
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
                hintText: 'Nhập tên thành phố (VD: Hanoi, London...)',
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

          // 2. KẾT QUẢ TÌM KIẾM
          Expanded(
            child: BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                // Đang tải tìm kiếm
                if (state is LocationSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Lỗi tìm kiếm
                if (state is LocationSearchError) {
                  return Center(
                    child: Text(
                      'Có lỗi xảy ra: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // Đã tải xong danh sách tìm kiếm
                if (state is LocationSearchLoaded) {
                  // TODO: Nếu chữ 'locations' bị đỏ -> xóa đi, gõ dấu chấm (.) rồi bấm Ctrl + Space để chọn biến danh sách của Dev A (VD: state.locations, state.results...)
                  final list = state.results;

                  if (list.isEmpty) {
                    return const Center(
                      child: Text('Không tìm thấy thành phố nào.'),
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

                // Chưa tìm kiếm (trạng thái ban đầu)
                return const Center(
                  child: Text('Hãy nhập tên thành phố để tìm kiếm'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}