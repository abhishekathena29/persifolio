class FirebasePortfolio {
  final String companyName;
  final String about;
  final String portfolioName;
  final String sectorSplit;
  final String where;
  final double diversification;

  FirebasePortfolio({
    required this.companyName,
    required this.about,
    required this.portfolioName,
    required this.sectorSplit,
    required this.where,
    required this.diversification,
  });

  factory FirebasePortfolio.fromMap(Map<String, dynamic> map) {
    return FirebasePortfolio(
      companyName: map['companyName'] ?? '',
      about: map['about'] ?? '',
      portfolioName: map['portfolioName'] ?? '',
      sectorSplit: map['sectorSplit'] ?? '',
      where: map['where'] ?? '',
      diversification: (map['diversification'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'about': about,
      'portfolioName': portfolioName,
      'sectorSplit': sectorSplit,
      'where': where,
      'diversification': diversification,
    };
  }
}

class PortfolioSector {
  final String name;
  final double percentage;
  final List<FirebasePortfolio> companies;
  final String description;

  PortfolioSector({
    required this.name,
    required this.percentage,
    required this.companies,
    required this.description,
  });

  factory PortfolioSector.fromCompanies(
      String sectorName, List<FirebasePortfolio> companies) {
    final totalDiversification = companies.fold<double>(
        0, (sum, company) => sum + company.diversification);
    final percentage = totalDiversification > 0 ? totalDiversification : 0.0;

    return PortfolioSector(
      name: sectorName,
      percentage: percentage,
      companies: companies,
      description: 'Companies in $sectorName sector',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'percentage': percentage,
      'companies': companies.map((company) => company.toMap()).toList(),
      'description': description,
    };
  }

  // Helper method to get instruments/where list for backward compatibility
  List<String> get instruments {
    return companies.map((company) => company.where).toSet().toList();
  }
}
