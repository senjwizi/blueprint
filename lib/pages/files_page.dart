import 'package:blueprint/models/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:blueprint/providers/app_state_provider.dart';

// Модели для файлового менеджера
enum FileType {
  folder,
  image,
  document,
  pdf,
  video,
  audio,
  code,
  archive,
  spreadsheet,
  presentation,
  other
}

enum SortBy { name, size, date, type }

enum ViewMode { grid, list }

class FileItem {
  final String id;
  final String name;
  final String path;
  final FileType type;
  final int size;
  final DateTime modifiedDate;
  final DateTime createdDate;
  final String? owner;
  final List<String> tags;
  final bool isFavorite;
  final bool isShared;
  final bool isHidden;

  FileItem({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.modifiedDate,
    required this.createdDate,
    this.owner,
    this.tags = const [],
    this.isFavorite = false,
    this.isShared = false,
    this.isHidden = false,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size Б';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} КБ';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} МБ';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} ГБ';
  }

  String get modifiedDateFormatted {
    final now = DateTime.now();
    final difference = now.difference(modifiedDate);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) return 'Только что';
        return '${difference.inMinutes} мин назад';
      }
      return '${difference.inHours} ч назад';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн назад';
    }
    return '${modifiedDate.day.toString().padLeft(2, '0')}.${modifiedDate.month.toString().padLeft(2, '0')}.${modifiedDate.year}';
  }
}

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  // Текущий путь - изначально корневая папка
  List<String> currentPath = ['Домашняя папка'];
  
  // Режим отображения
  ViewMode viewMode = ViewMode.grid;
  
  // Поиск
  String searchQuery = '';
  
  // Сортировка
  SortBy sortBy = SortBy.name;
  bool sortAscending = true;
  
  // Показывать скрытые файлы
  bool showHidden = false;
  
  // Выделенные файлы
  final Set<String> selectedFiles = {};
  
  // Все файлы и папки
  final List<FileItem> allItems = [
    // Папки
    FileItem(
      id: '1',
      name: 'Проекты',
      path: '/Домашняя папка/Проекты',
      type: FileType.folder,
      size: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      owner: 'Radmir',
      tags: ['работа'],
      isFavorite: true,
    ),
    FileItem(
      id: '2',
      name: 'Документы',
      path: '/Домашняя папка/Документы',
      type: FileType.folder,
      size: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 5)),
      createdDate: DateTime.now().subtract(const Duration(days: 60)),
      owner: 'Alice',
      tags: ['личное'],
    ),
    FileItem(
      id: '3',
      name: 'Изображения',
      path: '/Домашняя папка/Изображения',
      type: FileType.folder,
      size: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      createdDate: DateTime.now().subtract(const Duration(days: 45)),
      owner: 'Bob',
      tags: ['медиа'],
    ),
    FileItem(
      id: '4',
      name: '.config',
      path: '/Домашняя папка/.config',
      type: FileType.folder,
      size: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 10)),
      createdDate: DateTime.now().subtract(const Duration(days: 90)),
      owner: 'system',
      tags: ['системные'],
      isHidden: true,
    ),
    
    // Файлы в корне
    FileItem(
      id: '5',
      name: 'Отчет 2024.pdf',
      path: '/Домашняя папка/Отчет 2024.pdf',
      type: FileType.pdf,
      size: 2456789,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 3)),
      createdDate: DateTime.now().subtract(const Duration(days: 15)),
      owner: 'Radmir',
      tags: ['отчет', 'финансы'],
      isShared: true,
    ),
    FileItem(
      id: '6',
      name: 'Презентация.pptx',
      path: '/Домашняя папка/Презентация.pptx',
      type: FileType.presentation,
      size: 1567890,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      createdDate: DateTime.now().subtract(const Duration(days: 20)),
      owner: 'Alice',
      tags: ['презентация'],
    ),
    FileItem(
      id: '7',
      name: 'Дизайн.png',
      path: '/Домашняя папка/Дизайн.png',
      type: FileType.image,
      size: 3456789,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 5)),
      createdDate: DateTime.now().subtract(const Duration(days: 8)),
      owner: 'Alice',
      tags: ['дизайн'],
    ),
    FileItem(
      id: '8',
      name: 'main.dart',
      path: '/Домашняя папка/main.dart',
      type: FileType.code,
      size: 45678,
      modifiedDate: DateTime.now().subtract(const Duration(minutes: 30)),
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      owner: 'Radmir',
      tags: ['flutter'],
      isFavorite: true,
    ),
    FileItem(
      id: '9',
      name: 'архив.zip',
      path: '/Домашняя папка/архив.zip',
      type: FileType.archive,
      size: 12345678,
      modifiedDate: DateTime.now().subtract(const Duration(days: 7)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      owner: 'Alice',
      tags: ['бэкап'],
    ),
    FileItem(
      id: '10',
      name: 'демо.mp4',
      path: '/Домашняя папка/демо.mp4',
      type: FileType.video,
      size: 56789012,
      modifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      createdDate: DateTime.now().subtract(const Duration(days: 15)),
      owner: 'Radmir',
      tags: ['видео'],
    ),
    FileItem(
      id: '11',
      name: 'бюджет.xlsx',
      path: '/Домашняя папка/бюджет.xlsx',
      type: FileType.spreadsheet,
      size: 1234567,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 5)),
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      owner: 'Alice',
      tags: ['финансы'],
    ),
    FileItem(
      id: '12',
      name: '.env',
      path: '/Домашняя папка/.env',
      type: FileType.document,
      size: 1234,
      modifiedDate: DateTime.now().subtract(const Duration(days: 5)),
      createdDate: DateTime.now().subtract(const Duration(days: 50)),
      owner: 'system',
      tags: ['настройки'],
      isHidden: true,
    ),
  ];
  
  // Получаем элементы для текущего пути
List<FileItem> get currentItems {
  // Получаем текущий путь как строку
  String currentPathStr = '/${currentPath.join('/')}';
  
  // Фильтруем элементы по пути
  var filteredItems = allItems.where((item) {
    // Получаем путь папки, в которой находится элемент
    String itemDirectory = item.path.substring(0, item.path.lastIndexOf('/'));
    if (itemDirectory.isEmpty) itemDirectory = '/'; // Для корневых элементов
    
    // Проверяем, находится ли элемент в текущей папке
    if (itemDirectory != currentPathStr) return false;
    
    // Фильтр по поиску
    if (searchQuery.isNotEmpty) {
      if (!item.name.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
    }
    
    // Фильтр по скрытым файлам
    if (!showHidden && item.isHidden) return false;
    
    return true;
  }).toList();
    
    // Сортировка
    filteredItems.sort((a, b) {
      int compare;
      switch (sortBy) {
        case SortBy.name:
          compare = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortBy.size:
          compare = a.size.compareTo(b.size);
          break;
        case SortBy.date:
          compare = a.modifiedDate.compareTo(b.modifiedDate);
          break;
        case SortBy.type:
          compare = a.type.index.compareTo(b.type.index);
          break;
      }
      return sortAscending ? compare : -compare;
    });
    
    // Папки всегда в начале (кроме сортировки по типу)
    if (sortBy != SortBy.type) {
      filteredItems.sort((a, b) {
        if (a.type == FileType.folder && b.type != FileType.folder) return -1;
        if (a.type != FileType.folder && b.type == FileType.folder) return 1;
        return 0;
      });
    }
    
    return filteredItems;
  }
  
  // Получаем статистику
  Map<String, dynamic> get stats {
    final items = currentItems;
    int folderCount = items.where((item) => item.type == FileType.folder).length;
    int fileCount = items.length - folderCount;
    int totalSize = items.fold(0, (sum, item) => sum + item.size);
    
    return {
      'folders': folderCount,
      'files': fileCount,
      'totalSize': totalSize,
    };
  }
  
  String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes Б';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} КБ';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} ГБ';
  }
  
  // Получаем иконку для типа файла
  IconData getFileIcon(FileType type) {
    switch (type) {
      case FileType.folder:
        return Icons.folder;
      case FileType.image:
        return Icons.image;
      case FileType.document:
        return Icons.description;
      case FileType.pdf:
        return Icons.picture_as_pdf;
      case FileType.video:
        return Icons.videocam;
      case FileType.audio:
        return Icons.audiotrack;
      case FileType.code:
        return Icons.code;
      case FileType.archive:
        return Icons.archive;
      case FileType.spreadsheet:
        return Icons.table_chart;
      case FileType.presentation:
        return Icons.slideshow;
      case FileType.other:
        return Icons.insert_drive_file;
    }
  }
  
  // Получаем цвет для типа файла
  Color getFileColor(FileType type) {
    switch (type) {
      case FileType.folder:
        return Colors.amber;
      case FileType.image:
        return Colors.green;
      case FileType.document:
        return Colors.blue;
      case FileType.pdf:
        return Colors.red;
      case FileType.video:
        return Colors.purple;
      case FileType.audio:
        return Colors.pink;
      case FileType.code:
        return Colors.orange;
      case FileType.archive:
        return Colors.brown;
      case FileType.spreadsheet:
        return Colors.lightGreen;
      case FileType.presentation:
        return Colors.deepOrange;
      case FileType.other:
        return Colors.grey;
    }
  }
  
  // Получаем название типа файла
  String getFileTypeName(FileType type) {
    switch (type) {
      case FileType.folder:
        return 'Папка';
      case FileType.image:
        return 'Изображение';
      case FileType.document:
        return 'Документ';
      case FileType.pdf:
        return 'PDF';
      case FileType.video:
        return 'Видео';
      case FileType.audio:
        return 'Аудио';
      case FileType.code:
        return 'Код';
      case FileType.archive:
        return 'Архив';
      case FileType.spreadsheet:
        return 'Таблица';
      case FileType.presentation:
        return 'Презентация';
      case FileType.other:
        return 'Файл';
    }
  }
  
  // Навигация
  void navigateToFolder(String folderName) {
    setState(() {
      currentPath.add(folderName);
      selectedFiles.clear();
    });
  }
  
  void navigateBack() {
    if (currentPath.length > 1) {
      setState(() {
        currentPath.removeLast();
        selectedFiles.clear();
      });
    }
  }
  
  // Управление файлами
  void selectFile(String fileId) {
    setState(() {
      if (selectedFiles.contains(fileId)) {
        selectedFiles.remove(fileId);
      } else {
        selectedFiles.add(fileId);
      }
    });
  }
  
  void selectAll() {
    setState(() {
      if (selectedFiles.length == currentItems.length) {
        selectedFiles.clear();
      } else {
        selectedFiles.clear();
        selectedFiles.addAll(currentItems.map((item) => item.id));
      }
    });
  }
  
  void deleteSelected() {
    if (selectedFiles.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить файлы'),
        content: Text('Удалить ${selectedFiles.length} выбранных файлов?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // В реальном приложении здесь удаление из базы данных
              setState(() {
                selectedFiles.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Файлы удалены'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
  
  void showProperties(FileItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(getFileIcon(item.type), color: getFileColor(item.type)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Свойства: ${item.name}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPropertyRow('Тип', getFileTypeName(item.type)),
              _buildPropertyRow('Размер', item.sizeFormatted),
              _buildPropertyRow('Изменен', item.modifiedDateFormatted),
              _buildPropertyRow('Владелец', item.owner ?? 'Неизвестно'),
              _buildPropertyRow('Путь', item.path),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Теги:'),
                Wrap(
                  spacing: 8,
                  children: item.tags.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  if (item.isFavorite)
                    Chip(
                      label: const Text('Избранное'),
                      avatar: const Icon(Icons.star, size: 16),
                      backgroundColor: Colors.amber.withOpacity(0.1),
                    ),
                  if (item.isShared)
                    Chip(
                      label: const Text('Общий'),
                      avatar: const Icon(Icons.share, size: 16),
                      backgroundColor: Colors.green.withOpacity(0.1),
                    ),
                  if (item.isHidden)
                    Chip(
                      label: const Text('Скрытый'),
                      avatar: const Icon(Icons.visibility_off, size: 16),
                      backgroundColor: Colors.grey.withOpacity(0.1),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  void createFolder() {
    showDialog(
      context: context,
      builder: (context) {
        String folderName = '';
        return AlertDialog(
          title: const Text('Создать папку'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Введите название папки',
            ),
            onChanged: (value) => folderName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (folderName.isNotEmpty) {
                  // В реальном приложении здесь создание папки
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Папка "$folderName" создана'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }
  
  // Получаем текущую тему
  AppThemeType get currentTheme {
    final appState = AppStateProvider.getState(context);
    return appState?.theme ?? AppThemeType.dark;
  }
  
  AppColorPalette get palette => AppThemeManager.getPalette(currentTheme);

  @override
  Widget build(BuildContext context) {
    final items = currentItems;
    final hasSelection = selectedFiles.isNotEmpty;
    
    return Scaffold(
      backgroundColor: palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: palette.panelBackground,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.folder, color: Colors.teal),
            ),
            const SizedBox(width: 12),
            const Text('Файловый менеджер'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: palette.panelBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Навигация
                SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      if (currentPath.length > 1)
                        IconButton(
                          onPressed: navigateBack,
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentPath.length,
                          itemBuilder: (context, index) {
                            final isLast = index == currentPath.length - 1;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPath = currentPath.sublist(0, index + 1);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isLast ? palette.accent.withOpacity(0.1) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  currentPath[index],
                                  style: TextStyle(
                                    color: isLast ? palette.accent : palette.secondaryText,
                                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.chevron_right, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Панель инструментов
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${stats['folders']} папок, ${stats['files']} файлов',
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (hasSelection)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: palette.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Выбрано: ${selectedFiles.length}',
                          style: TextStyle(
                            color: palette.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          viewMode = viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
                        });
                      },
                      icon: Icon(
                        viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
                        size: 20,
                      ),
                      tooltip: 'Сменить вид',
                    ),
                    PopupMenuButton<SortBy>(
                      icon: const Icon(Icons.sort, size: 20),
                      onSelected: (value) {
                        setState(() {
                          if (sortBy == value) {
                            sortAscending = !sortAscending;
                          } else {
                            sortBy = value;
                            sortAscending = true;
                          }
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: SortBy.name,
                          child: Row(
                            children: [
                              const Icon(Icons.sort_by_alpha),
                              const SizedBox(width: 8),
                              const Text('По имени'),
                              if (sortBy == SortBy.name)
                                Icon(
                                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortBy.size,
                          child: Row(
                            children: [
                              const Icon(Icons.storage),
                              const SizedBox(width: 8),
                              const Text('По размеру'),
                              if (sortBy == SortBy.size)
                                Icon(
                                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortBy.date,
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              const Text('По дате'),
                              if (sortBy == SortBy.date)
                                Icon(
                                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Поисковая панель
          Container(
            padding: const EdgeInsets.all(16),
            color: palette.panelBackground,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск файлов...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: createFolder,
                  icon: const Icon(Icons.create_new_folder),
                  tooltip: 'Создать папку',
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      showHidden = !showHidden;
                    });
                  },
                  icon: Icon(
                    showHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  tooltip: showHidden ? 'Скрыть системные' : 'Показать скрытые',
                ),
                IconButton(
                  onPressed: selectAll,
                  icon: const Icon(Icons.select_all),
                  tooltip: 'Выбрать все',
                ),
              ],
            ),
          ),
          
          // Контент
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 80,
                          color: palette.secondaryText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Папка пуста',
                          style: TextStyle(
                            color: palette.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Создайте папку или загрузите файлы',
                          style: TextStyle(
                            color: palette.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                : viewMode == ViewMode.grid
                    ? _buildGridView(items)
                    : _buildListView(items),
          ),
        ],
      ),
      floatingActionButton: hasSelection
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: deleteSelected,
                  backgroundColor: Colors.red,
                  mini: true,
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Поделиться файлами'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  backgroundColor: palette.accent,
                  mini: true,
                  child: const Icon(Icons.share),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Загрузить файл'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: palette.accent,
              child: const Icon(Icons.upload),
            ),
    );
  }
  
  Widget _buildGridView(List<FileItem> items) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedFiles.contains(item.id);
          
          return GestureDetector(
            onTap: () {
              if (item.type == FileType.folder) {
                navigateToFolder(item.name);
              } else {
                selectFile(item.id);
              }
            },
            onLongPress: () => showProperties(item),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.accent.withOpacity(0.1)
                    : palette.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? palette.accent : palette.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  // Иконка
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: getFileColor(item.type).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              getFileIcon(item.type),
                              color: getFileColor(item.type),
                              size: 40,
                            ),
                          ),
                          if (item.isHidden)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Icon(
                                Icons.visibility_off,
                                color: palette.secondaryText,
                                size: 16,
                              ),
                            ),
                          if (item.isFavorite)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          if (item.isShared)
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Icon(
                                Icons.share,
                                color: palette.accent,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Информация
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: item.isHidden ? palette.secondaryText : palette.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.modifiedDateFormatted,
                          style: TextStyle(
                            color: palette.secondaryText,
                            fontSize: 10,
                          ),
                        ),
                        if (item.type != FileType.folder) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.sizeFormatted,
                            style: TextStyle(
                              color: palette.secondaryText,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildListView(List<FileItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedFiles.contains(item.id);
        
        return GestureDetector(
          onTap: () {
            if (item.type == FileType.folder) {
              navigateToFolder(item.name);
            } else {
              selectFile(item.id);
            }
          },
          onLongPress: () => showProperties(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? palette.accent.withOpacity(0.1)
                  : palette.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? palette.accent : palette.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: getFileColor(item.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    getFileIcon(item.type),
                    color: getFileColor(item.type),
                    size: 24,
                  ),
                ),
              ),
              title: Row(
                children: [
                  if (item.isHidden)
                    Icon(Icons.visibility_off, size: 14, color: palette.secondaryText),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        color: item.isHidden ? palette.secondaryText : palette.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.isFavorite)
                    Icon(Icons.star, color: Colors.amber, size: 16),
                  if (item.isShared)
                    Icon(Icons.share, color: palette.accent, size: 16),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    item.modifiedDateFormatted,
                    style: TextStyle(
                      color: palette.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  if (item.type != FileType.folder) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: palette.secondaryText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.sizeFormatted,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text('Свойства'),
                      ],
                    ),
                    onTap: () => showProperties(item),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 8),
                        Text('В избранное'),
                      ],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Добавлено в избранное'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Удалить'),
                      ],
                    ),
                    onTap: () {
                      selectFile(item.id);
                      deleteSelected();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}