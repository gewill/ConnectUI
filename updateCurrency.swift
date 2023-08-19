import Foundation

// 目标URL和目标文件路径
let url = URL(string: "https://www.floatrates.com/daily/usd.json")!
let filePath = "./ConnectUI/Model/currency.json"

func downloadAndWriteFile() async {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 将数据写入文件
        let fileURL = URL(fileURLWithPath: filePath)
        try data.write(to: fileURL)
        print("File written to: \(fileURL.path)")
    } catch {
        print("Error: \(error)")
    }
}

// 异步执行下载和写入文件操作
Task {
    await downloadAndWriteFile()
    
    // 结束程序
    exit(0)
}

// 让任务运行一段时间（等待异步操作完成）
RunLoop.main.run()
