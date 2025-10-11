// import 'package:flutter/material.dart';
// import 'package:persifolio/services/transaction_service.dart';
// import 'package:persifolio/models/portfolio_models.dart';
// import 'package:intl/intl.dart';

// class TransactionHistoryPage extends StatefulWidget {
//   const TransactionHistoryPage({super.key});

//   @override
//   State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
// }

// class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
//   List<Transaction> _transactions = [];
//   bool _isLoading = true;
//   String _filterType = 'All';
//   final List<String> _filterOptions = ['All', 'Buy', 'Sell'];

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactions();
//   }

//   Future<void> _loadTransactions() async {
//     setState(() => _isLoading = true);
//     try {
//       final transactions =
//           await TransactionService.getTransactionHistory(limit: 100);
//       setState(() {
//         _transactions = transactions;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading transactions: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   List<Transaction> get _filteredTransactions {
//     if (_filterType == 'All') return _transactions;
//     return _transactions
//         .where((t) =>
//             t.type.toString().split('.').last.toLowerCase() ==
//             _filterType.toLowerCase())
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F0F),
//       appBar: AppBar(
//         title: const Text('Transaction History'),
//         backgroundColor: const Color(0xFF1A1A1A),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.filter_list),
//             onSelected: (value) {
//               setState(() => _filterType = value);
//             },
//             itemBuilder: (context) => _filterOptions.map((option) {
//               return PopupMenuItem(
//                 value: option,
//                 child: Row(
//                   children: [
//                     Icon(
//                       _filterType == option
//                           ? Icons.check
//                           : Icons.radio_button_unchecked,
//                       color: _filterType == option
//                           ? const Color(0xFFFF6B35)
//                           : Colors.grey,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(option),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
//               ),
//             )
//           : _transactions.isEmpty
//               ? _buildEmptyState()
//               : RefreshIndicator(
//                   onRefresh: _loadTransactions,
//                   color: const Color(0xFFFF6B35),
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _filteredTransactions.length,
//                     itemBuilder: (context, index) {
//                       final transaction = _filteredTransactions[index];
//                       return _buildTransactionCard(transaction);
//                     },
//                   ),
//                 ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFF6B35).withOpacity(0.2),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: const Icon(
//               Icons.receipt_long,
//               size: 48,
//               color: Color(0xFFFF6B35),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'No Transactions Yet',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start trading to see your transaction history here',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[400],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionCard(Transaction transaction) {
//     final isBuy = transaction.type == TransactionType.buy;
//     final color = isBuy ? Colors.green : Colors.red;
//     final icon = isBuy ? Icons.add_circle : Icons.remove_circle;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           isBuy ? 'BUY' : 'SELL',
//                           style: TextStyle(
//                             color: color,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           transaction.symbol,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       transaction.stockName,
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '₹${transaction.totalAmount.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '${transaction.shares} × ₹${transaction.price.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 DateFormat('MMM dd, yyyy • HH:mm')
//                     .format(transaction.timestamp),
//                 style: TextStyle(
//                   color: Colors.grey[500],
//                   fontSize: 12,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(transaction.status).withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   _getStatusText(transaction.status),
//                   style: TextStyle(
//                     color: _getStatusColor(transaction.status),
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(TransactionStatus status) {
//     switch (status) {
//       case TransactionStatus.completed:
//         return Colors.green;
//       case TransactionStatus.pending:
//         return Colors.orange;
//       case TransactionStatus.failed:
//         return Colors.red;
//       case TransactionStatus.cancelled:
//         return Colors.grey;
//     }
//   }

//   String _getStatusText(TransactionStatus status) {
//     switch (status) {
//       case TransactionStatus.completed:
//         return 'COMPLETED';
//       case TransactionStatus.pending:
//         return 'PENDING';
//       case TransactionStatus.failed:
//         return 'FAILED';
//       case TransactionStatus.cancelled:
//         return 'CANCELLED';
//     }
//   }
// }
