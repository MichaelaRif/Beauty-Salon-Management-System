using Newtonsoft.Json;
using System.Net.Http.Headers;

namespace BSMS.BusinessLayer.Services
{
    public class UserInfoService : IUserInfoService
    {
        private readonly HttpClient _httpClient;

        public UserInfoService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<UserInfo> GetUserInfoAsync(string accessToken)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, "http://localhost:8088/realms/Angular-Keycloak/protocol/openid-connect/userinfo");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var response = await _httpClient.SendAsync(request);

            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve user info. Status code: {response.StatusCode}, Reason: {response.ReasonPhrase}");
            }

            var userInfoJson = await response.Content.ReadAsStringAsync();

            var userInfo = JsonConvert.DeserializeObject<UserInfo>(userInfoJson);

            if (!string.IsNullOrEmpty(userInfoJson))
            {
                var jsonObject = JsonConvert.DeserializeObject<Dictionary<string, string>>(userInfoJson);

                if (jsonObject?.TryGetValue("date_of_birth", out var dob) == true && DateOnly.TryParse(dob, out var dateOfBirth))
                {
                    userInfo.DateOfBirth = dateOfBirth;
                }
            }

            return userInfo;
        }
    }
}
