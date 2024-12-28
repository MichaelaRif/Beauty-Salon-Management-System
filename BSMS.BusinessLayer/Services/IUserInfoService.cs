namespace BSMS.BusinessLayer.Services
{
    public interface IUserInfoService
    {
        Task<UserInfo> GetUserInfoAsync(string accessToken);
    }

}
