import { Injectable } from '@nestjs/common';
import { AdminRepository } from './admin.repository';
import { RevenueDto } from './dto/response/revenue.dto';

@Injectable()
export class AdminService {
  constructor(private readonly adminRepository: AdminRepository) {}

  async getRevenue() {
    let data: RevenueDto[] = [];

    // Fetch users and payments concurrently
    const [users] = await Promise.all([this.adminRepository.getUsers()]);

    for (const user of users) {
      const { id, fullName, email } = user;

      const row: RevenueDto = { id, fullName, email };

      const [channel, totalTopUp, totalDonations] = await Promise.all([
        this.adminRepository.getChannelByUserId(id),
        this.adminRepository.getSumTopUp(id),
        this.adminRepository.getSumDonation(id),
      ]);

      row.totalEarnings = +channel?.totalREPs || 0;
      row.totalTopUp = +totalTopUp || 0;
      row.totalDonations = +totalDonations || 0;

      if (row.totalTopUp != 0 || row.totalDonations != 0 || row.totalEarnings != 0) data.push(row);
    }

    return data;
  }
}
