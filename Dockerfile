FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app
# 複製 sln csproj and restore nuget
COPY *.sln .
# 目標路徑資料夾要與來源路徑資料夾名稱相同(因 sln 已儲存專案路徑)
COPY TestDocker/*.csproj ./TestDocker/
# nuget restore
RUN dotnet restore
# 複製其他檔案
COPY TestDocker/. ./TestDocker/
WORKDIR /app/TestDocker
# 使用 Release 建置專案並輸出至 out
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app
# 將產出物複製至 app 下
COPY --from=build /app/TestDocker/out ./
# 啟動 TestDokcer
ENTRYPOINT ["dotnet", "TestDocker.dll"]
