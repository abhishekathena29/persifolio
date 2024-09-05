import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StockPortfolioModel {
  String portfolioName;
  String sectorSplit;
  double diversification;
  String where;
  String companyName;
  String companyAbout;
  Timestamp addedDate;
  StockPortfolioModel({
    required this.portfolioName,
    required this.sectorSplit,
    required this.diversification,
    required this.where,
    required this.companyName,
    required this.companyAbout,
    required this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'portfolioName': portfolioName,
      'sectorSplit': sectorSplit,
      'diversification': diversification,
      'where': where,
      'companyName': companyName,
      'companyAbout': companyAbout,
      'addedDate': addedDate,
    };
  }

  factory StockPortfolioModel.fromMap(Map<String, dynamic> map) {
    return StockPortfolioModel(
      portfolioName: map['portfolioName'] ?? '',
      sectorSplit: map['sectorSplit'] ?? '',
      diversification: map['diversification']?.toDouble() ?? 0.0,
      where: map['where'] ?? '',
      companyName: map['companyName'] ?? '',
      companyAbout: map['companyAbout'] ?? '',
      addedDate: map['addedDate'],
    );
  }
}
