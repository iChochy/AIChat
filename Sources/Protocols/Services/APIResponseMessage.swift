//
//  AIService.swift
//  iChat
//
//  Created by Lion on 2025/4/25.
//

import Foundation

// API 响应消息结构 (根据具体 API 调整)
struct APIResponseMessage: Decodable {
    let choices: [Choice]?
    struct Choice: Decodable {
        let delta: Delta?
    }
}

struct Delta: Decodable {
    let content: String?
    let reasoning: String?
    enum CodingKeys: String, CodingKey {
        case content
        case reasoning = "reasoning_content"
    }
}

// 验证响应
func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw AIError.InvalidResponse
    }
    guard (200...299).contains(httpResponse.statusCode) else {
        print(httpResponse.statusCode)
        throw StatusError(rawValue: httpResponse.statusCode)
            ?? StatusError.SystemError
    }
}

// 错误类型
enum AIError: LocalizedError {
    case MissingProvider
    case WrongAPIURL
    case InvalidResponse
    case SystemError

}

enum StatusError: Int, LocalizedError {
    // 2xx Success (成功)
    case OK = 200  // 请求成功
    case Created = 201  // 已创建：请求成功并在服务器上创建了新的资源
    case Accepted = 202  // 已接受：请求已接受处理，但处理尚未完成
    case NoContent = 204  // 无内容：服务器已成功处理请求，但没有返回任何内容 (例如 DELETE 请求成功)

    // 3xx Redirection (重定向)
    case MultipleChoices = 300  // 多种选择：针对请求有多种可能的响应
    case MovedPermanently = 301  // 永久移动：请求的资源已被永久移动到新的 URL
    case Found = 302  // 已找到 (原名 Moved Temporarily)：请求的资源暂时在不同的 URL 下
    case SeeOther = 303  // 查看其他：请求的资源应该从另一个 URI 使用 GET 方法获取
    case NotModified = 304  // 未修改：客户端缓存的资源是最新的，无需再次传输
    case TemporaryRedirect = 307  // 临时重定向：请求的资源暂时在不同的 URL 下，且不允许改变请求方法
    case PermanentRedirect = 308  // 永久重定向：请求的资源已被永久移动到新的 URL，且不允许改变请求方法

    // 4xx Client Error (客户端错误)
    case BadRequest = 400  // 错误请求：服务器无法理解请求，可能是由于请求语法错误
    case Unauthorized = 401  // 未授权：请求需要用户身份验证 (与 AuthError 含义相同)
    case Forbidden = 403  // 禁止：服务器理解请求，但拒绝执行。通常是因为缺乏访问权限
    case ResourceNotFound = 404  // 未找到：服务器找不到请求的资源 (常见错误，如页面不存在)
    case MethodNotAllowed = 405  // 方法不允许：服务器理解请求方法，但目标资源不支持该方法
    case NotAcceptable = 406  // 不可接受：服务器无法根据请求的 'Accept' 头生成响应
    case RequestTimeout = 408  // 请求超时：服务器在指定时间内没有收到完整的请求
    case Conflict = 409  // 冲突：请求与目标资源的当前状态冲突 (例如，尝试创建已存在的资源)
    case Gone = 410  // 已失效：请求的资源在服务器上已不再可用，且没有转发地址
    case LengthRequired = 411  // 需要长度：服务器拒绝在没有定义 Content-Length 的请求
    case PreconditionFailed = 412  // 前置条件失败：客户端请求中的某些前置条件未满足
    case PayloadTooLarge = 413  // 有效载荷过大：请求实体比服务器能处理的要大
    case URITooLong = 414  // URI 过长：请求的 URI 比服务器能处理的要长
    case UnsupportedMediaType = 415  // 不支持的媒体类型：请求的媒体类型不被服务器支持
    case RangeNotSatisfiable = 416  // 范围未满足：客户端请求的范围超出资源的可用范围
    case ExpectationFailed = 417  // 期望失败：请求的 Expect 头字段值与服务器期望的不符
    case UnprocessableEntity = 422  // 不可处理实体：请求格式正确，但包含语义错误 (常用于验证失败，与 ValidationFailed 含义相同)
    case TooManyRequests = 429  // 请求过多：用户在给定时间内发送了太多请求 (速率限制)

    // 5xx Server Error (服务器错误)
    case InternalServerError = 500  // 内部服务器错误：服务器遇到了一个意外情况，阻止它完成请求
    case NotImplemented = 501  // 未实现：服务器不支持完成请求所需的功能
    case BadGateway = 502  // 错误的网关：服务器作为网关或代理，从上游服务器收到无效响应
    case ServiceUnavailable = 503  // 服务不可用：服务器目前无法处理请求，可能是由于临时过载或维护
    case GatewayTimeout = 504  // 网关超时：服务器作为网关或代理，没有及时从上游服务器收到响应

    // Custom/Non-standard errors (自定义/非标准错误)
    case SystemError = 999  // 自定义系统错误，不在标准 HTTP 范围，可能用于客户端内部逻辑

    func compare(_ code: Int) -> Bool {
        return self.rawValue == code
    }
}

struct ModelResponse: Codable {
    let data: [Model]
}

struct Model: Codable, Identifiable {
    var id: String
    //Gemini 统一修改
    var name: String {
        id.replacingOccurrences(of: "models/", with: "")
    }

}

// 请求体模型
struct StreamRequestBody: Codable {
    let model: String
    let messages: [[String: String]]
    let temperature:Double
    let stream: Bool
    var extraBody:ExtraBody?
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case stream
        case extraBody = "extra_body"
    }
}


// 外层结构：extra_body
struct ExtraBody: Codable {
    let google: Google
}

// 内层结构：google
struct Google: Codable {
    let thinkingConfig: ThinkingConfig
    
    // 处理下划线键名转换为驼峰式
    enum CodingKeys: String, CodingKey {
        case thinkingConfig = "thinking_config"
    }
}

// 最内层结构：thinking_config
struct ThinkingConfig: Codable {
    let includeThoughts: Bool = true
    
    // 处理下划线键名转换为驼峰式
    enum CodingKeys: String, CodingKey {
        case includeThoughts = "include_thoughts"
    }
}

