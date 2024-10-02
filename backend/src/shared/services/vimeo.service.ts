import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { ApiConfigService } from './api-config.service';
import axios from 'axios';
import { ERRORS_DICTIONARY } from '../constraints/error-dictionary.constraint';

@Injectable()
export class VimeoService {
  private readonly accessToken: string;
  private readonly apiUrl: string;
  constructor(public configService: ApiConfigService) {
    const { accessTokenVimeo, apiUrlVimeo } = this.configService.vimeoConfig;
    this.accessToken = accessTokenVimeo;
    this.apiUrl = apiUrlVimeo;
  }

  async createUploadSession(fileSize: number) {
    try {
      const response = await axios.post(
        `${this.apiUrl}/me/videos`,
        {
          upload: {
            approach: 'tus',
            size: `${fileSize}`,
          },
        },
        {
          headers: {
            Authorization: `Bearer ${this.accessToken}`,
            'Content-Type': 'application/json',
            Accept: 'application/vnd.vimeo.*+json;version=3.4',
          },
        },
      );

      const upload = response.data;
      return {
        linkUpLoad: upload.upload.upload_link,
        linkVideo: upload.uri,
      };
    } catch (error) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.UPLOAD_VIDEO_FAIL,
      });
    }
  }

  async getVideoDetails(url: string): Promise<any> {
    try {
      const response = await axios.get(url, {
        headers: {
          Authorization: `Bearer ${this.accessToken}`,
        },
      });
      return response.data;
    } catch (error) {
      throw new NotFoundException({
        message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
      });
    }
  }

  async delete(url: string): Promise<any> {
    try {
      const response = await axios.delete(url, {
        headers: {
          Authorization: `Bearer ${this.accessToken}`,
        },
      });

      return response.status;
    } catch (error) {
      throw new NotFoundException({
        message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
      });
    }
  }
}