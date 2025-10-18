import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// İnternet bağlantı durumunu kontrol eden ve gösteren ana widget sınıfı
class ConnectivityExample extends StatefulWidget {
  const ConnectivityExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConnectivityExampleState createState() => _ConnectivityExampleState();
}

class _ConnectivityExampleState extends State<ConnectivityExample> {
  // Connectivity plugin instance'ı
  final Connectivity _connectivity = Connectivity();

  // İnternet bağlantı durumunu tutan değişken
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  // Stream subscription - bağlantı değişikliklerini dinlemek için
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Bağlantı durumu geçmişini tutan liste
  List<String> _connectionHistory = [];

  // Manuel kontrol yapılıp yapılmadığını gösteren değişken
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // İlk bağlantı durumunu kontrol et
    _initConnectivity();
    // Bağlantı değişikliklerini dinlemeye başla
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    // Stream subscription'ı temizle (memory leak'i önlemek için)
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // İlk bağlantı durumunu kontrol eden fonksiyon
  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      // Mevcut bağlantı durumunu al
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      // Hata durumunda none olarak ayarla
      result = [ConnectivityResult.none];
    }

    // UI'yi güncelle - ilk bağlantıyı al
    if (mounted) {
      setState(() {
        _connectionStatus =
            result.isNotEmpty ? result.first : ConnectivityResult.none;
      });
    }
  }

  // Bağlantı durumu değiştiğinde çağrılan fonksiyon
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    ConnectivityResult status =
        result.isNotEmpty ? result.first : ConnectivityResult.none;
    setState(() {
      _connectionStatus = status;
    });

    // Bağlantı değişikliğini geçmişe ekle
    _addToHistory('Otomatik: ${_getConnectionStatusText(status)}');
  }

  // Manuel bağlantı kontrolü yapan fonksiyon
  Future<void> _checkConnectivity() async {
    setState(() {
      _isChecking = true;
    });

    try {
      // Bağlantı durumunu kontrol et
      final result = await _connectivity.checkConnectivity();
      ConnectivityResult status =
          result.isNotEmpty ? result.first : ConnectivityResult.none;

      setState(() {
        _connectionStatus = status;
      });

      // Manuel kontrolü geçmişe ekle
      _addToHistory('Manuel: ${_getConnectionStatusText(status)}');
    } catch (e) {
      // Hata durumunda kullanıcıya bildir
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı kontrolü sırasında hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  // Bağlantı durumunu geçmişe ekleyen fonksiyon
  void _addToHistory(String entry) {
    setState(() {
      _connectionHistory.insert(
          0, '${DateTime.now().toString().substring(11, 19)} - $entry');
      // Geçmişi 10 öğe ile sınırla
      if (_connectionHistory.length > 10) {
        _connectionHistory.removeLast();
      }
    });
  }

  // Bağlantı durumunu metin olarak döndüren fonksiyon
  String _getConnectionStatusText(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi Bağlantısı';
      case ConnectivityResult.mobile:
        return 'Mobil Veri Bağlantısı';
      case ConnectivityResult.ethernet:
        return 'Ethernet Bağlantısı';
      case ConnectivityResult.vpn:
        return 'VPN Bağlantısı';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth Bağlantısı';
      case ConnectivityResult.other:
        return 'Diğer Bağlantı';
      case ConnectivityResult.none:
      default:
        return 'Bağlantı Yok';
    }
  }

  // Bağlantı durumuna göre ikon döndüren fonksiyon
  IconData _getConnectionIcon(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.ethernet:
        return Icons.cable;
      case ConnectivityResult.vpn:
        return Icons.vpn_key;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.other:
        return Icons.device_hub;
      case ConnectivityResult.none:
      default:
        return Icons.wifi_off;
    }
  }

  // Bağlantı durumuna göre renk döndüren fonksiyon
  Color _getConnectionColor(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Colors.green;
      case ConnectivityResult.mobile:
        return Colors.blue;
      case ConnectivityResult.ethernet:
        return Colors.orange;
      case ConnectivityResult.vpn:
        return Colors.purple;
      case ConnectivityResult.bluetooth:
        return Colors.indigo;
      case ConnectivityResult.other:
        return Colors.amber;
      case ConnectivityResult.none:
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Plus Demo'),
        backgroundColor: _getConnectionColor(_connectionStatus),
        foregroundColor: Colors.white,
        actions: [
          // Bağlantı durumu ikonu
          Icon(_getConnectionIcon(_connectionStatus)),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getConnectionColor(_connectionStatus).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana bağlantı durumu kartı
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getConnectionColor(_connectionStatus),
                      _getConnectionColor(_connectionStatus).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Bağlantı ikonu
                    Icon(
                      _getConnectionIcon(_connectionStatus),
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    // Bağlantı durumu metni
                    Text(
                      _getConnectionStatusText(_connectionStatus),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Durum açıklaması
                    Text(
                      _connectionStatus == ConnectivityResult.none
                          ? 'İnternet bağlantısı bulunamadı'
                          : 'Bağlantı aktif ve çalışıyor',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Kontrol butonları
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _checkConnectivity,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                        _isChecking ? 'Kontrol Ediliyor...' : 'Manuel Kontrol'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _connectionHistory.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Geçmişi Temizle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bağlantı geçmişi başlığı
            Text(
              'Bağlantı Geçmişi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            // Bağlantı geçmişi listesi
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _connectionHistory.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Henüz bağlantı geçmişi yok',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Bağlantı durumu değiştiğinde\nburada görünecek',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _connectionHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Icon(
                                Icons.access_time,
                                color: Colors.blue[600],
                                size: 20,
                              ),
                            ),
                            title: Text(
                              _connectionHistory[index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Bilgi notu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu uygulama otomatik olarak bağlantı değişikliklerini algılar ve geçmişe kaydeder.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
