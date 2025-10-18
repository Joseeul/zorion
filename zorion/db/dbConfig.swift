//
//  dbConfig.swift
//  zorion
//
//  Created by Jose Andreas on 16/10/25.
//

import Foundation
import Supabase

// db password: JNmGlFiaBuWpKQCq

struct DBConfig {
    let url: URL
    let key: String
}

let dbConfig = DBConfig(
    url: URL(string: "https://ucnsoqyiwllelwmcimzh.supabase.co")!,
    key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjbnNvcXlpd2xsZWx3bWNpbXpoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1OTAzNTYsImV4cCI6MjA3NjE2NjM1Nn0.g3KDdNtKiYqILNMy3F_y004p9tvcuJd_U_kABHwiUd4"
)

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(supabaseURL: dbConfig.url, supabaseKey: dbConfig.key)
    }
}
