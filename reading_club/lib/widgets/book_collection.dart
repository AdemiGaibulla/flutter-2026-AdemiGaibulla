import 'package:flutter/material.dart';
import 'package:reading_club/models/book.dart';

class BookCollection extends StatelessWidget{
  final List<Book> books;
  final void Function(Book) onToggleFavourite;
  final void Function(Book) onBookTap;

  const BookCollection({super.key, required this.books, required this.onToggleFavourite, required this.onBookTap});

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
        builder: (context, constraints) {
          if(constraints.maxWidth < 600) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return _buildCard(context, books[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: books.length,
            );
          }

          return GridView.builder(
            gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              childAspectRatio: 1.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return _buildCard(context, books[index]);
            },
            itemCount: books.length,
          );
        },
    );
  }

  Widget _buildCard(BuildContext context, Book book) {
    return InkWell(
      onTap: () => onBookTap(book),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.menu_book),
                  ),
                  if (book.isFull || book.free <= 5)
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        child: Text(
                          book.isFull ? 'FULL' : '${book.free} left',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${book.when.day}.${book.when.month}.${book.when.year}',
                    ),
                    Text(book.place),
                    Text('${book.count}/${book.limit} places taken'),
                    if (book.description case final description?)
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onToggleFavourite(book),
                icon: Icon(
                  book.favourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
