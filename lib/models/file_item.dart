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
  final int size; // в байтах
  final DateTime modifiedDate;
  final DateTime createdDate;
  final String? thumbnailUrl;
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
    this.thumbnailUrl,
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

  String get createdDateFormatted {
    return '${createdDate.day.toString().padLeft(2, '0')}.${createdDate.month.toString().padLeft(2, '0')}.${createdDate.year}';
  }

  String get fileExtension {
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  String get displayName {
    if (isHidden && name.startsWith('.')) {
      return name;
    }
    return name;
  }

  FileItem copyWith({
    String? id,
    String? name,
    String? path,
    FileType? type,
    int? size,
    DateTime? modifiedDate,
    DateTime? createdDate,
    String? thumbnailUrl,
    String? owner,
    List<String>? tags,
    bool? isFavorite,
    bool? isShared,
    bool? isHidden,
  }) {
    return FileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      createdDate: createdDate ?? this.createdDate,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      owner: owner ?? this.owner,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isShared: isShared ?? this.isShared,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

class FolderStats {
  final int folderCount;
  final int fileCount;
  final int totalSize;
  
  FolderStats({
    required this.folderCount,
    required this.fileCount,
    required this.totalSize,
  });

  String get totalSizeFormatted {
    if (totalSize < 1024) return '$totalSize Б';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(1)} КБ';
    if (totalSize < 1024 * 1024 * 1024) return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} МБ';
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} ГБ';
  }
}