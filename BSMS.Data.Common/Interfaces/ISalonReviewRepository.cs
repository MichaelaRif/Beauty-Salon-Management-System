using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ISalonReviewRepository : 
        IRepositoryQuery<SalonReview>, 
        IRepositoryPost<SalonReview>
    {
        Task<IEnumerable<SalonReview>?> GetTopAsync();
        Task DeleteAsync(int customerId, int salonReviewId);
    }
}
