import SwiftUI

// MARK: - Settings View (Arabic Translation)
struct SettingsView_ar: View {
    @ObservedObject var setup: SetupCoordinator
    @ObservedObject var actions: LocationActionCoordinator
    @ObservedObject private var proxy = ProxyManager.shared
    @ObservedObject private var runtimeMode = ProxyRuntimeModeStore.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            // قسم 1: وضع التشغيل
            Section("وضع التشغيل") {
                Picker("الوضع", selection: Binding(
                    get: { runtimeMode.mode },
                    set: { newMode in switchRuntimeMode(to: newMode) }
                )) {
                    Text("Wi-Fi محلي").tag(.localWiFi)
                    Text("جهة خارجية").tag(.thirdParty)
                }
                .pickerStyle(.inline)
            }
            
            // قسم 2: الحالة
            Section("الحالة") {
                HStack {
                    Label(proxy.isRunning ? "محرك proxy نشط" : "محرك proxy غير نشط", 
                          systemImage: proxy.isRunning ? "play.circle.fill" : "stop.circle")
                    Spacer()
                }
                
                HStack {
                    Label("الموقع الافتراضي", systemImage: "location.fill")
                    Spacer()
                    Text(actions.currentLocationName ?? "غير محدد").foregroundStyle(.secondary)
                }
            }
            
            // قسم 3: التكوين المتقدم
            Section("التكوين") {
                Button {
                    openGitHubRepo()
                } label: {
                    Label("مستودع GitHub", systemImage: "github")
                }
                
                Button {
                    checkForUpdates()
                } label: {
                    Label("التحقق من التحديثات", systemImage: "arrow.clockwise")
                }
            }
            
            // قسم 4: معلومات التطبيق
            Section("حول التطبيق") {
                Text("Paopao Location Spoofer v1.0")
                    .font(.headline)
                Text("© 2026 Paopao Labs. جميع الحقوق محفوظة.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("الإعدادات")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { Button("العودة") { dismiss() } }
        }
    }
    
    private func switchRuntimeMode(to newMode: ProxyRuntimeMode) {
        // منطق تغيير الوضع
    }
    
    private func openGitHubRepo() {
        if let url = URL(string: "https://github.com/xweiba/location-spoofer") {
            UIApplication.shared.open(url)
        }
    }
    
    private func checkForUpdates() {
        // منطق التحقق من التحديثات
    }
}
