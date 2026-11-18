class Court {
  final String id;
  final String name;
  final String location;
  final String rating;
  final int price;
  final String image;

  const Court({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.image,
  });
}

const List<Court> courts = [
  Court(
    id: 'court_1',
    name: 'Gor Istora Senayan',
    location: 'Jakarta, Indonesia',
    rating: '9.5',
    price: 50000,
    image:
    'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=1200',
  ),
  Court(
    id: 'court_2',
    name: 'GOR Bulungan',
    location: 'Jakarta, Indonesia',
    rating: '9.2',
    price: 45000,
    image:
    'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=1200',
  ),
  Court(
    id: 'court_3',
    name: 'PB Djarum Arena',
    location: 'Jakarta, Indonesia',
    rating: '9.7',
    price: 55000,
    image:
    'https://images.unsplash.com/photo-1613918431703-aa50889e3be1?w=1200',
  ),
  Court(
    id: 'court_4',
    name: 'Badminton Sports Club',
    location: 'Jakarta, Indonesia',
    rating: '8.9',
    price: 40000,
    image:
    'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?w=1200',
  ),
  Court(
    id: 'court_5',
    name: 'Green Sports Arena',
    location: 'Jakarta, Indonesia',
    rating: '9.8',
    price: 60000,
    image:
    'https://images.unsplash.com/photo-1599058917212-d750089bc07b?w=1200',
  ),
];
