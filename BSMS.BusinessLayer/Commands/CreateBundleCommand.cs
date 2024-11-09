﻿using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateBundleCommand : IRequest<BundleDto>
    {
        public string BundleName { get; set; } = null!;
        public string? BundleDescription { get; set; }
        public decimal BundlePrice { get; set; }
    }
}
