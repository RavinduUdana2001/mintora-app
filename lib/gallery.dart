import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mintora/GalleryDetailPage';
import 'package:video_player/video_player.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> galleryItems = [];
  List<dynamic> filteredGalleryItems = [];
  bool isLoading = true;
  bool isGrid = true;
  final String apiUrl = 'https://apps.aichallengecoin.com/app/gallery.php';

  TextEditingController searchController = TextEditingController(); // Controller for search bar

  @override
  void initState() {
    super.initState();
    fetchGallery();
    searchController.addListener(_filterGallery); // Add listener to the search controller
  }

  Future<void> fetchGallery() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            galleryItems = data['data'];
            filteredGalleryItems = galleryItems; // Initially, show all items
            isLoading = false;
          });
        }
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  // Filter the gallery items based on search input
  void _filterGallery() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredGalleryItems = galleryItems.where((item) {
        final title = item['header']?.toLowerCase() ?? '';
        final description = item['description']?.toLowerCase() ?? '';
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  // Function to handle the refresh action when the user pulls down
  Future<void> _refreshGallery() async {
    setState(() {
      isLoading = true;  // Set loading to true while fetching
    });
    await fetchGallery();  // Fetch gallery data again
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        title: const Text('Gallery', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_agenda : Icons.view_module, color: Colors.white),
            onPressed: () => setState(() => isGrid = !isGrid),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.tealAccent))
          : RefreshIndicator(
              onRefresh: _refreshGallery, // Refresh function called when pull-to-refresh is triggered
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Search bar at the top
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search by title or description',
                          hintStyle: const TextStyle(color: Colors.white60),
                          filled: true,
                          fillColor: const Color(0xFF2b2d42),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),

                    // Gallery grid or list based on user's choice
                    Expanded(
                      child: GridView.builder(
                        itemCount: filteredGalleryItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isGrid ? 2 : 1,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: isGrid ? 0.75 : 1.4,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredGalleryItems[index];
                          final images = [
                            item['image1'],
                            item['image2'],
                            item['image3']
                          ].where((img) => img != null && img.toString().isNotEmpty).map((e) => e.toString()).toList();

                          final video = item['video'];
                          final hasVideo = video != null && video.toString().isNotEmpty;
                          final mediaItems = [...images];
                          if (hasVideo) mediaItems.add(video);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GalleryDetailPage(item: item), // Navigate to detailed page
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2b2d42),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: MediaSlider(mediaItems: mediaItems, imageCount: images.length),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['header'] ?? '',
                                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2, // Show only 2 lines of the header
                                          overflow: TextOverflow.ellipsis, // Handle text overflow
                                        ),
                                        const SizedBox(height: 6),
                                        Text(item['description'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class MediaSlider extends StatefulWidget {
  final List<String> mediaItems;
  final int imageCount;

  const MediaSlider({super.key, required this.mediaItems, required this.imageCount});

  @override
  State<MediaSlider> createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  late PageController _controller;
  int currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (currentPage + 1) % widget.mediaItems.length;
      _controller.animateToPage(nextPage, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.mediaItems.length,
          onPageChanged: (index) => setState(() => currentPage = index),
          itemBuilder: (context, index) {
            if (index < widget.imageCount) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.mediaItems[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white70)),
                ),
              );
            } else {
              return AutoPlayVideo(videoUrl: widget.mediaItems[index]);
            }
          },
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.mediaItems.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 10 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.white : Colors.white30,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class AutoPlayVideo extends StatefulWidget {
  final String videoUrl;
  const AutoPlayVideo({super.key, required this.videoUrl});

  @override
  State<AutoPlayVideo> createState() => _AutoPlayVideoState();
}

class _AutoPlayVideoState extends State<AutoPlayVideo> {
  late VideoPlayerController _controller;
  bool failedToLoad = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => isInitialized = true);
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      }).catchError((_) {
        setState(() => failedToLoad = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (failedToLoad) {
      return const Center(child: Icon(Icons.error_outline, color: Colors.redAccent, size: 48));
    }

    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
