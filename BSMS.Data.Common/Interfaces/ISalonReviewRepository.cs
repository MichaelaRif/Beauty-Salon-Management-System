using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ISalonReviewRepository : 
        IRepositoryQuery<SalonReview>, 
        IRepositoryPost<SalonReview>, 
        IRepositoryDelete<SalonReview>
    {
        Task<IEnumerable<SalonReview>?> GetTopAsync();
    }
}
