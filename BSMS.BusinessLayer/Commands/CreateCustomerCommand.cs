using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateCustomerCommand : IRequest<CustomerDto>
    {
        public string CustomerFn { get; set; } = null!;
        public string CustomerLn { get; set; } = null!;
        public string? CustomerEmail { get; set; }
        public string? CustomerPn { get; set; }
        public string CustomerPasshash { get; set; } = null!;
        public DateOnly CustomerDob { get; set; }
        public string CustomerPronouns { get; set; } = null!;
        public string CityName { get; set; } = null!;
        public string? Preferences { get; set; }
        public bool Promotions { get; set; }
        public string? CustomerPfp { get; set; }
        public bool IsGoogle { get; set; }
        public bool IsApple { get; set; }
        public bool Is2fa { get; set; }
    }
}
