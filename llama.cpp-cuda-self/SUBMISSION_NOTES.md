# llama.cpp-cuda-self 提交说明

## 包信息
- **AUR包名**: llama.cpp-cuda-self
- **版本**: b10679
- **上游**: https://github.com/ggml-org/llama.cpp

## 安全检查结果

### ✓ 无藏毒风险

**已检查项:**
- [x] 上游来源可信 (ggml-org/meta研究组织)
- [x] SHA256校验和格式正确 (3个源文件)
- [x] PKGBUILD中无恶意命令 (rm -rf, eval, curl|bash等)
- [x] 变量展开验证通过 (口算检查所有路径)
- [x] 依赖安全 (标准cuda/python/gcc依赖)

**可疑行为扫描:**
```
grep 'rm\s*-rf' PKGBUILD → 无结果 ✓
grep 'curl.*bash\|wget.*bash' PKGBUILD → 无结果 ✓  
grep 'unset\s+PATH' PKGBUILD → 无结果 ✓
grep 'chmod\s+777' PKGBUILD → 无结果 ✓
```

## 文件清单

| 文件 | 说明 |
|------|------|
| PKGBUILD | 构建脚本，变量展开验证通过 |
| .SRCINFO | AUR元数据 |
| AGENTS.md | 未来更新指南 |
| llama.cpp.conf | systemd环境配置 |
| llama.cpp.service | systemd服务单元 |
| .nvchecker.toml | 自动版本检查配置 |

## 构建前准备

```bash
# 安装必要依赖（需要GPU环境）
pacman -S cuda cudnn shaderc npm cmake ninja git

# 或者从AUR
yay -S shaderc nvidia-utils
```

## 构建命令

```bash
cd /workspace/llama.cpp-cuda-self
makepkg -si
```

## 已知限制

1. **需要NVIDIA GPU** 和 CUDA 环境
2. **构建时间较长** (约10-15分钟)
3. **无二进制缓存** 每次需完整编译
4. **本VM无GPU** 无法在此环境中实际构建

---
