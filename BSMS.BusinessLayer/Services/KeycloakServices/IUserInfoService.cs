namespace BSMS.BusinessLayer.Services.KeycloakServices
{
    public interface IUserInfoService
    {
        Task<UserInfo> GetUserInfoAsync(string accessToken);
    }

}
